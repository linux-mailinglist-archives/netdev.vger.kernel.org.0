Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63333212DF8
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 22:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgGBUnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 16:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGBUnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 16:43:02 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28063C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 13:43:02 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id r12so18213603ilh.4
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 13:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TN9BZZcwYpr4I3XDDf0rHvbAfOB9BgaanEdq+qYlStE=;
        b=jKudLezyHQhPdBWgUUgSXs+APSusj9GTBhiXWRQmLOJJGjC5pgFb2T9MTtJaXRNMlm
         bbmNXQ0mRqD39/eQcynN6xnWY+mjFTTcCObOSseVYe7QBUD42bDzEVvK/+DUIFtjLgAN
         6Rikcwqe1L8N7IpQRcDF2Jonu6fRDphkGAJV743JOSFwSzMlp9z41G6eC/WgV3AB8ev+
         rcLyPMbdqZEEVmfVTpVpUbtPXORZAtLTrF5zy4CvbVudlZMsFZK3p67mb10ZGTZVFC0H
         JiXyxAVAsMRyRy4hmLNwbrSTcCV/eK6mwBACleUpLEKYKqb4sshtykJpV+YDBoeSiwv+
         Qegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TN9BZZcwYpr4I3XDDf0rHvbAfOB9BgaanEdq+qYlStE=;
        b=qo4m2xMqPPLpNf5UBqVoOIighu5nQNFEQWWUAWnomc5HAYMniMko05YUsFy3DVRXfl
         nFVTqMKo9xbeLzfYoTRCokAxWGKGEbaQoTSrGXgmDGCxGV+LZX3CtejlSfaH8oy1sfTB
         lbxN7GTRpIErglaCXunFBAkqtjBlpHcNu72xsiFel59Nr8Nkgo8c26cvm+lUE59BZYxg
         WDjj4tMOBciWiBYwyH+0bvx4EBnrhnRyl3ejpt0WMF4CVWaWV2+Kcoonq7nQXs+FALzN
         1ZJ2MFGgo+WcTQRA8Yvk3KX8k5+pkijINVzgQKXrPBQBlXvE1RwDJlHZMIgqbZepAt9c
         zyKw==
X-Gm-Message-State: AOAM533GvWapDWEDueEjjM+RXZdV6qzwbY+LnW1H2uagjXk6UZIk9y9X
        rMqT02JuloIlM9bY113fSFkhO9XWOdL90yqgpGk=
X-Google-Smtp-Source: ABdhPJzT9EhXlsiRQ7l4cm0Swo/2bE0slKeWgPdRkKTZz4Q7U1AbyOsydWb+c7fbIKqKYutC+Zda8BfXB9GPkRwVpDw=
X-Received: by 2002:a92:5857:: with SMTP id m84mr14469817ilb.144.1593722581250;
 Thu, 02 Jul 2020 13:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200618221548.3805-1-lariel@mellanox.com> <20200618221548.3805-2-lariel@mellanox.com>
 <000266053809204e05e2dba71d62fab734cf6c97.camel@redhat.com> <00f14b6d-cd58-b1e0-4ba9-803b31aac41f@mellanox.com>
In-Reply-To: <00f14b6d-cd58-b1e0-4ba9-803b31aac41f@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 2 Jul 2020 13:42:50 -0700
Message-ID: <CAM_iQpUYMWgucCgqDO5fQXW5aY7WXKvbVM=ERwx2-TobKEPShQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action hash
To:     Ariel Levkovich <lariel@mellanox.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 7:42 PM Ariel Levkovich <lariel@mellanox.com> wrote:
> I'll try to address both of your comments regarding existing
> alternatives to this new action
>
> here so that we can have a single thread about it.
>
> Act_bpf indeed can provide a similar functionality. Furthermore, there
> are already existing BPF helpers
>
> to allow user to change skb->hash within the BPF program, so there's no
> need to perform act_skbedit
>
> after act_bpf.

What is "perform act_skbedit after act_bpf"? You mentioned avoiding
act_bpf is one of your goals here.


>
>
> However, since we are trying to offer the user multiple methods to
> calculate the hash, and not only
>
> using a BPF program, act_bpf on its own is not enough.

If this is the reason for you to add a new action, why not just extend
act_skbedit?


>
> If we are looking at HW offload (as Daniel mentioned), like I mentioned
> in the cover letter,
>
> it is important that SW will be able to get the same hash result as in
> HW for a certain packet.
>
> When certain HW is not able to forward TC the hash result, using a BPF
> program that mimics the
>
> HW hash function is useful to maintain consistency but there are cases
> where the HW can and
>
> does forward the hash value via the received packet's metadata and the
> vendor driver already
>
> fills in the skb->hash with this value. In such cases BPF program usage
> can be avoided.
>
> So to sum it up, this api is offering user both ways to calculate the hash:
>
> 1. Use the value that is already there (If the vendor driver already set
> it. If not, calculate using Linux jhash).

Can be done by extending act_skbedit?

>
> 2. Use a given BPF program to calculate the hash and to set skb->hash
> with it.

Seems you agreed this can be done via act_bpf.

>
>
> It's true, you can cover both cases with BPF - meaning, always use BPF
> even if HW/driver can provide hash
>
> to TC in other means but we thought about giving an option to avoid
> writing and using BPF when
>
> it's not necessary.

How about extending act_skbedit? Adding TCA_SKBEDIT_HASH?

Thanks.
