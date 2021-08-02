Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3193DDE35
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 19:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhHBRJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 13:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhHBRJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 13:09:23 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A011C06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 10:09:14 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so6871178pjs.0
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 10:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TbYPxVaMbJVYxNQRLXF2hPwysjXj2BHuUt5OSy6Yi9U=;
        b=DUl5PfyJzqeHFqi3/eTm19A06VVy10rY2p3RX5Cxfp7uo3QGysHYj/1gobb2wzxuCS
         ApVR4EZIaR/JhO2+YwNGVl4t5/iDKppyMi7skYCLqeWxxXAJLyNVmnwAEHQ2Jzg1/z45
         90L3ciVHCTpzBLh1zEGCzlHvZC5E8wEfaLkfJgobYprpB/UVgNxd6+9nYXktwPCsOV0N
         YxGTg8Sb1rIVXxLUKlgADSdiDNa52rwBgFojpZdtKzsx8lhsCQIgJ25V6ScL9qoC5D7F
         ysAV4DNalm09/1Gp1j3NCkeId0PGt0Hm9ORe5yBt/s8KQUKfY6RzjjADeRpaOzhv93aC
         6SuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TbYPxVaMbJVYxNQRLXF2hPwysjXj2BHuUt5OSy6Yi9U=;
        b=uQTznfLgwUSZt/96QbrxgpZcl53nAOU6NRgVF6ZzVwV6sOPnbjTzBxk6SV+rxpuYCT
         VGD6AFZa2QlAou83VpTN5ewjMq4oDeMZVKYW3XN8EuosTCGssvuMZSbH/p5H1Zsq4fjB
         57RejK17A0BuG6Lg0uCLuDUHZoPdjjG/s+3Lq6vmNEaCLRcTCRWwjvjBt2U0/dpG+6HB
         XM1+Z+hoTzh9joZnVVugOq1oXXPA42+oVGUTBjKSQHFe6i38Mtff3eMkAxUthcF9XfGV
         oUXU2LT5P3FYU5hydKiuBOv9rLI5RMFsJv2ZHc8qyvITyF36DyZeRXIgVNlMkYVcGoqA
         MciA==
X-Gm-Message-State: AOAM532MGrvGhA8l1SZE/8VkyF8vIvk0QfdsJ3CNP1x/JgPvTPYAHBfK
        DFt4OKZONv9fVuR4/JjNWbw=
X-Google-Smtp-Source: ABdhPJwx8moCzRrtOzm/ACUF3x0h+eVC7WV0ap38928/UUL7HTpkFgNd90rPtgRoHtR9fnyfTF0pwQ==
X-Received: by 2002:a62:8143:0:b029:3a9:bdb9:b2c3 with SMTP id t64-20020a6281430000b02903a9bdb9b2c3mr17729137pfd.7.1627924153691;
        Mon, 02 Aug 2021 10:09:13 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q7sm11132041pjq.36.2021.08.02.10.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 10:09:13 -0700 (PDT)
Date:   Mon, 2 Aug 2021 10:09:10 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH net-next v3] ptp: ocp: Expose various resources on the
 timecard.
Message-ID: <20210802170910.GB9832@hoboy.vegasvil.org>
References: <20210802165157.1706690-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802165157.1706690-1-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 09:51:57AM -0700, Jonathan Lemon wrote:

> The resources are collected under a driver procfs directory:
> 
>   [jlemon@timecard ~]$ ls -g /proc/driver/ocp1

I thought that adding new stuff under /proc was stopped years ago?

Thanks,
Richard
