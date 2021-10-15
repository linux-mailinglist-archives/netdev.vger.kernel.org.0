Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD7842E678
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhJOCY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbhJOCYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 22:24:54 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC3AC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 19:22:49 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id cv2so4908363qvb.5
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 19:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j8HHbZRpYt8dYVOh9U53np7zOR0OtBavUvWM+AaBjR4=;
        b=ni9yApiar9FYap+XVIuqodS1urP5e9XRmCYAqkdvD9jVRlaoph0n7bU6DsuR5GmMQH
         qYuCJ+WmZUfvln7QukUegl+Iqc1DwG+C+h15tEhdt9Y+PA4DzSOJmZByHiDDxTtynt0E
         1xFY/IUCNW4h1Ysr6cpRZMPywI0ZQ9KM4GalwgrS2NyeILK7cQa8aBz+RjcYMaYtzcAX
         eiljAZVcpRgJjquc8ToeEbck4gKXdJwuqmOlseKy3d5DjjW0jOBAZl09nUzjb1YO2iTK
         a7aON98cIi6RDmzGiMyYd1yLAMkbG1+/FAD9wcF+GXt5FaHtSVg0e5UadcnkaLeF3rS9
         GUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j8HHbZRpYt8dYVOh9U53np7zOR0OtBavUvWM+AaBjR4=;
        b=CW57Gf/0HdvMZvydnX+brX1d//AU/yio9etfn5F3aEmCY8qxJvkuJyvEtPDaCe2QKs
         azF6UvyWqQWL7CacbF28ffYXJOJr0CS1hp3PvM+ErYJGLrCHR+LGUJXP6QnlMRhwNAfA
         9/YLb8bCPaW1h78ntb85mKs7JqHyN8Zqd7jf+nf467HuYHheiPfXvY5PMypHRo2eJWel
         fjBjFneHZ6DKJD7ArmM0Bd/Tc76TUlktLS5yYmUBU4+rMrr7aZuALKdZRau3/3h0T+H9
         2+mhgCouxUNX+BjK1wwzkl3B+9vB/DvOjWfeRy0ZFrY/czHkfw7HMcz7ANtmclwqwc7K
         PFmg==
X-Gm-Message-State: AOAM5315OXcPm9V+qoIl5ACRtFDM/XzimFWv9AsYGEXCi+0OOIVRNZqD
        j4HO3pNmdl2czhrP7Cex4w==
X-Google-Smtp-Source: ABdhPJwouM14RYAPSOHRURW15WEnyZivGCvLVOmh04aUZUqv03iD/n8S3bqfO3Sub9XqZqk5qr8AZA==
X-Received: by 2002:a05:6214:1269:: with SMTP id r9mr8987160qvv.23.1634264568511;
        Thu, 14 Oct 2021 19:22:48 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id o190sm2088631qka.16.2021.10.14.19.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 19:22:48 -0700 (PDT)
Date:   Thu, 14 Oct 2021 22:22:41 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net] ipv6: When forwarding count rx stats on the orig
 netdev
Message-ID: <20211015022241.GA3405@ICIPI.localdomain>
References: <20211014130845.410602-1-ssuryaextr@gmail.com>
 <1a83de45-936e-483c-0176-c877d8548d70@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a83de45-936e-483c-0176-c877d8548d70@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 08:15:34PM -0600, David Ahern wrote:
> [ added Ido for the forwarding tests ]
> 
[snip]
> 
> This seems fine to me, but IPv4 and IPv6 should work the same.

But we don't have per if ipv4 stats. Remember that I tried to get
something going but wasn't getting any traction?
