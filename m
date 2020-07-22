Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C16C22A0E4
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732949AbgGVUqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732945AbgGVUqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 16:46:51 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AA3C0619DC;
        Wed, 22 Jul 2020 13:46:51 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id s23so2861277qtq.12;
        Wed, 22 Jul 2020 13:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6g/oY2rXZp/ah/KvdD1F4yFw3y8W5VmdfHR2Fxxsxj0=;
        b=a7SDEOy4r0WOF5T1EZ3ZNB4eg26yja5DMv+IRgjx3atVZrq/mKEZpI6FMDcbfLleTX
         8Br4XJbxHfvl9dzf7awm0TylRoJnSq/4WipKsc3wVJnaVAKKekOnT/mQr9STfb3x0N6g
         xBKlAlf3SNSCEQhJjKdXd/we1NCYkiNps66MOHCuLVJZIJfmeltJx0P8FlnEoOYWcCxY
         8AHXhpR/oyxsPhWKzLazDhdHOSNIE2IfFbzpIuHNnPIvpz6ShPTGksBZKvrAlyh/0ntG
         aY9eN0RCqjH2NYkF/8ChFicYFPAoWIDp2gJ//53Oq5Mayh5wOiNiajNeoq8mUgVV+tcC
         yrfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6g/oY2rXZp/ah/KvdD1F4yFw3y8W5VmdfHR2Fxxsxj0=;
        b=QaQeUs8BX3QL/DL/hXrLEyCWy8IzWNOhAwsW5GAqS8q53MRusaFUnugJL0to96JkI+
         /lQF83RjM2t/Z0Ke+TSqR48UZzxq/N5zXeK5noOd2X+MhEq1N8VFHGmV367OQEwoPrTc
         j2mrFBMrYhmDl21OBB9LOQmFSlxwEY50GQlK8VmPQY3nM6NVOwx33wFmB00+V8jlD5eN
         RYfQ+sZSckrvkfQf5NYR4G5VIuw4A1hYyfLk6qS0VRgJO96FaAj8QJxz2skAHFmEvCqT
         hgArAX1DFkyM5hGCVEDkMB/YIagQPlHMTmS++oYdm1LINue6UppOrNIOHYP+oOfuAj71
         /r7A==
X-Gm-Message-State: AOAM533iN3UOwzN8B9TuRhnsHqo2/5JaPDt2Y8XrmELaSRY98CkHmgHD
        DQ/NYRZUz4hRVzTnc9ZXD833DXK1
X-Google-Smtp-Source: ABdhPJwrmyDnSnD14JyiZD2+eh8JmsRMXY5ogFdkw4IlaA3qRD08kxU3cgLsBi3VWnp8b6DzCFVpGQ==
X-Received: by 2002:ac8:5542:: with SMTP id o2mr1207455qtr.47.1595450810450;
        Wed, 22 Jul 2020 13:46:50 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:a4f2:f184:dd41:1f10:d998])
        by smtp.gmail.com with ESMTPSA id i19sm749001qkk.68.2020.07.22.13.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 13:46:49 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 51F42C18B3; Wed, 22 Jul 2020 17:46:47 -0300 (-03)
Date:   Wed, 22 Jul 2020 17:46:47 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net 0/2] sctp: shrink stream outq in the right place
Message-ID: <20200722204647.GB3399@localhost.localdomain>
References: <cover.1595433039.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1595433039.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:52:10PM +0800, Xin Long wrote:
> Patch 1 is an improvement, and Patch 2 is a bug fix.
> 
> Xin Long (2):
>   sctp: shrink stream outq only when new outcnt < old outcnt
>   sctp: shrink stream outq when fails to do addstream reconf

Nice changelogs, thanks.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
