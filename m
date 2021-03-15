Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31E833ABDA
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 07:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCOG6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 02:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhCOG5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 02:57:45 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DEFC061574;
        Sun, 14 Mar 2021 23:57:45 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso14202846pjb.3;
        Sun, 14 Mar 2021 23:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2WJG9vdfKxOZhSEaxthz6mUtiHSSJOtcmVCeDoWEgKw=;
        b=NW4bj6wiNRTsYnO7ZzWf1Z9lySTzcUUP3DCR4dAByrxAZn9Ska7TovcgusQW1r95ly
         5zG0wAtCyLWdNbmw9betsOEm7soCXZCkFp3iSoFm8Rgvr6hOuAAEkEnPF4W5HHyuND3p
         IyCbeoqqwcKNTczZO7b7lRhEs3gVvaaY1MFdt4XD9f5MJ9zaPWa21QC3XSqdqIal+p4g
         zH8ARar3weTQ7knugIcTfVb/N8qPql+fPqgu3g+Pr1p1uyEn9l77UV679fsJjksv+ee4
         MNSAzvmvxHZDk0FhmnTB/8oZ0y4UklH+gPg8Wtq4drueTOjs/+MC36wdFZf6nVwJXInr
         ZUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2WJG9vdfKxOZhSEaxthz6mUtiHSSJOtcmVCeDoWEgKw=;
        b=tdWBxeBe1PCBO2LqzQl+pRQWF6qJ4c9F4MaYy7Y9ptPKuweiKBUPk3KD80BZOKZ4QA
         yaDuw1MYZz/r1RYHrAh6IdiADhMwjn5xQX7QBqgR9b7oqQftBa3NoHxMjGmOTiBxDsxf
         pD37rEiChSZ0WMUJBhz+6zmAFYPYNMy1dE1zPEUIQg2FrzfEFdn9Th9EX8Po6RjWirGl
         Dbs34HbOiNlQLzNmBYV1ggNebDLuqGuvulAl5nSvZEN3iY27uMbQ74oD28u12Fw4TuCf
         dNKGEwNzmVHaOEjif1nPNWz+NdbBIvpQ8Bvh+0zWVk5sqYTdwyApipm7yVfaPbZB0Sad
         s2CA==
X-Gm-Message-State: AOAM531HliKGLv6meekg/75uKV/kmUSTmGZ0BkHMwT7feZDXLwoF+onS
        4JhWJqrUtLfYdGJln6K7tx0=
X-Google-Smtp-Source: ABdhPJy2CfR1Uf8f5FCVjhKz8jvGKp+9q6aJTYq68c4/UuCaJZ7bqrO7RNgjfYou0WLAxYSeiLHnSQ==
X-Received: by 2002:a17:90a:5d10:: with SMTP id s16mr11370076pji.126.1615791465320;
        Sun, 14 Mar 2021 23:57:45 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s26sm12340280pfd.5.2021.03.14.23.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:57:44 -0700 (PDT)
Date:   Mon, 15 Mar 2021 14:57:34 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Yi-Hung Wei <yihung.wei@gmail.com>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: Re: [PATCH net] selftests/bpf: set gopt opt_class to 0 if get tunnel
 opt failed
Message-ID: <20210315065734.GA2900@Leo-laptop-t470s>
References: <20210309032214.2112438-1-liuhangbin@gmail.com>
 <20210312015617.GZ2900@Leo-laptop-t470s>
 <0b5c810b-5eec-c7b0-15fc-81c989494202@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b5c810b-5eec-c7b0-15fc-81c989494202@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 04:15:27PM +0100, Daniel Borkmann wrote:
> On 3/12/21 2:56 AM, Hangbin Liu wrote:
> > Hi David,
> > 
> > May I ask what's the status of this patch? From patchwork[1] the state is
> > accepted. But I can't find the fix on net or net-next.
> 
> I think there may have been two confusions, i) that $subject says that this goes
> via net tree instead of bpf tree, which might have caused auto-delegation to move
> this into 'netdev' patchwork reviewer bucket, and ii) the kernel patchwork bot then
> had a mismatch as you noticed when it checked net-next after tree merge and replied
> to the wrong patch of yours which then placed this one into 'accepted' state. I just
> delegated it to bpf and placed it back under review..
> 
> > [1] https://patchwork.kernel.org/project/netdevbpf/patch/20210309032214.2112438-1-liuhangbin@gmail.com/

Thanks Daniel, I thought the issue also exists on net tree and is a fixup. So
I set the target to 'net'.

Hangbin
