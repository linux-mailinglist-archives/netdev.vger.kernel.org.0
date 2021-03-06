Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B9132FC84
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 19:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhCFShU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 13:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhCFShM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 13:37:12 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC08AC06174A
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 10:37:12 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id f33so5149126otf.11
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 10:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eSsgjyRRIvFeN1TCRVSi7QLr9PE9/ieiuv6FbOJru3Y=;
        b=iEImuB01BnN5j+PF1H5DU37+x4JVUwEFLXU43IhRQGJHUqQc8I3pAfqYQZ81wo4GD+
         4+cpVC3ILGapeq6ETEzg+ylzCwSw9Ubosi7N/h3Qbr8KVy4yg8IHXsMe69WWCscwokVZ
         B+3hixWmi/K7/+zgDWKvNVH4VlE+bk4/gEsMZ0h6pli961xfdgnELCY8JXxizSEk2Q5x
         VrIPMKrtUqrTJtGnS0utGV3xVmSM7oyOK5wf2JGjeq/kJ9vQMpnkuWZk+6rKUM1WIJiv
         aSPaZwFA1pGoPLzLVJivF0/3EIhxi/aupw80pUAEYGnJ4WWa81xljlQxr5TM/neuvkMi
         JzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eSsgjyRRIvFeN1TCRVSi7QLr9PE9/ieiuv6FbOJru3Y=;
        b=G72o/GrI6TrnYZEU6BTkAapSPrOGOp3c+1O39LSbb5UMV2q0B4pCz8QTz0dDCB9BEO
         V+ACE66RmqgZpB/EeOqkDobSrjscv5Xvuh67xiOGoK2qRSRKIu4MW/10ruaoHMIxnS+h
         MORqV5B8kTqUCs+Ix9u8tqE2XfPVKEE5+5YpVyxqP+OCP7lvDdHHptys+Jp0b9mmxasH
         Fl7p5nZHbNsEO9BFG3Waf0+Q1waGpIz2TsKAXO2hL+MArHF2ildltspt3KPgLEx8QQ24
         q2FHVmzN5WrquMEjMRnNiHf7u2OFXJ/xMD93e5IHP2quFY/2HyVvWObAeMu6Na6ThNzB
         eKvA==
X-Gm-Message-State: AOAM532fwXOJvvHH6sDgpiIJAvrIMc+Fb/Kig5Wh6qw/EedbifJ9tOQP
        vl0GRh7vcWpyzM5NQN1eAvagKG9X48k2wP3br/A=
X-Google-Smtp-Source: ABdhPJxW4tDp5TfmpLM20l0QrMhKu0ChaGZ/XVSH8sH2a1YJp6MxlHoyLccTSze6sDUHdWqDJ8D9ifgY58WAGfG1gck=
X-Received: by 2002:a9d:6081:: with SMTP id m1mr8344111otj.38.1615055832085;
 Sat, 06 Mar 2021 10:37:12 -0800 (PST)
MIME-Version: 1.0
References: <CAJH0kmzrf4MpubB1RdcP9mu1baLM0YcN-MXKY41ouFHxD8ndNg@mail.gmail.com>
 <20210302174451.59341082@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJH0kmyTgLp4rJGL1EYo4hQ_qcd3t3JQS-s-e9FY8ERTPrmwqQ@mail.gmail.com>
 <20210304095110.7830dce4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJH0kmzTD2+zbTWrBxN0_2f4A266YhoUTFa4-Tcg+Obx=TDqgA@mail.gmail.com> <20210305141857.1e6e60a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210305141857.1e6e60a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Zbynek Michl <zbynek.michl@gmail.com>
Date:   Sat, 6 Mar 2021 19:36:59 +0100
Message-ID: <CAJH0kmw00RHaKXqxRFi-7aSj2waYaMBYpp3v1fnC-=237BEKZA@mail.gmail.com>
Subject: Re: [regression] Kernel panic on resume from sleep
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Great, I submitted the patch and marked it for stable inclusion!
>
> It should percolate through the trees in a couple of weeks.

Cool. Jakub, thank you very much for your awesome assistance!

Zbynek
