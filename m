Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAD136A2DD
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 22:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbhDXUIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 16:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbhDXUIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 16:08:39 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0457C061574;
        Sat, 24 Apr 2021 13:08:00 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id i21-20020a05600c3555b029012eae2af5d4so3009574wmq.4;
        Sat, 24 Apr 2021 13:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LDzpKyv4bl1xGnzF7Wpb4vKjNdoqHae2obXlUpf2F/8=;
        b=LtffXWZzHSmBGsnNc0jaIUiKfCVL1MOhGDfoNa0hFC8RV3avFu6SYVJl2fqIQ8dn8k
         JN88kEkHVemzgCSBN6WWVLAeDsWzH2D/YRflF/zrP7wawDv+ZxYRvQSwpljaXKyNnv1k
         HaiaNAjYJrtWYQ264Bv3MmNnVzT824EgoJexA31aPRdvSK7vtWpPPh3Rag7Y3TDB4ked
         3iq9m3+oH/2nq+cJVeydeqxHIUjGaTsl08EukpXazEKtNUumOj9Tg2GTA66MgfW7wL9O
         jfrZMorvuSxi8KFDZ2L6prdms2WtOsTRZoJb8sZfj5cNScj60p00JgceZllW+feftCLk
         iYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LDzpKyv4bl1xGnzF7Wpb4vKjNdoqHae2obXlUpf2F/8=;
        b=BTPlnSY30h1U6cXR8seU78NnTx+d8j3Xt44f+BHO2Be7+IrNovHw0tc/bR1U4AmWCZ
         LR5uOz/MR6iB/ga1ZSX9Yarqz0BvEc1RxDeKYGcWHdBn19F/vNNdJ6um1mCmNUf3BrLY
         VSizDLtItfD3BY9dYjwONTBTZLhmJIkdGLBkLlHv0baTPZ28MVsjfUid479y11DAo6Zj
         ACo+p07iEPk90xuKl2ZZKxop/AeJlC2TPh70+gv9MiYzS5qaHdjhiBTo2ZTAzF8fwc63
         cx3TPSPjQEKq0yEE0oMhjCBL59OMuc4mkLsqVRjtUigMW+pSW9MNfldxodVvW/IkY7h7
         96Qw==
X-Gm-Message-State: AOAM5315A73sMz4syhWbgoBFFlVk5fcj5m8sj5+svFZScIPPuSrj+Oxl
        b2sokhHeR8wwCoYOgmYNh2erH0hOHc9tuw==
X-Google-Smtp-Source: ABdhPJzPw/nAQPwEdo2bT8HUX4LUvI/MWD7JZuaCeGVk8zu1EKyr90sZF6+a2YnxDp9XTMR99IBE2w==
X-Received: by 2002:a1c:7516:: with SMTP id o22mr12054653wmc.91.1619294878998;
        Sat, 24 Apr 2021 13:07:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:d4b:63c:654f:4f21? (p200300ea8f3846000d4b063c654f4f21.dip0.t-ipconnect.de. [2003:ea:8f38:4600:d4b:63c:654f:4f21])
        by smtp.googlemail.com with ESMTPSA id g9sm11469796wmh.21.2021.04.24.13.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Apr 2021 13:07:58 -0700 (PDT)
To:     AceLan Kao <acelan.kao@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210420075406.64105-1-acelan.kao@canonical.com>
 <CANn89iJLSmtBNoDo8QJ6a0MzsHjdLB0Pf=cs9e4g8Y6-KuFiMQ@mail.gmail.com>
 <20210420122715.2066b537@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFv23Q=ywiuZp7Y=bj=SAZmDdAnanAXA954hdO3GpkjmDo=RpQ@mail.gmail.com>
 <c10a6c72-9db7-18c8-6b03-1f8c40b8fd87@gmail.com>
 <CAFv23QkUsTf5M0MoUEFNYeFCtShAn3EmA3u8vXVeZyJa20Bx=g@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: called rtnl_unlock() before runpm resumes devices
Message-ID: <f06e0e2b-c6bb-ef5a-f629-d1ab82b7aee2@gmail.com>
Date:   Sat, 24 Apr 2021 22:07:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAFv23QkUsTf5M0MoUEFNYeFCtShAn3EmA3u8vXVeZyJa20Bx=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.04.2021 05:42, AceLan Kao wrote:
> Heiner Kallweit <hkallweit1@gmail.com> 於 2021年4月22日 週四 下午3:09寫道：
>>
>> On 22.04.2021 08:30, AceLan Kao wrote:
>>> Yes, should add
>>>
>>> Fixes: 9474933caf21 ("igb: close/suspend race in netif_device_detach")
>>> and also
>>> Fixes: 9513d2a5dc7f ("igc: Add legacy power management support")
>>>
>> Please don't top-post. Apart from that:
>> If the issue was introduced with driver changes, then adding a workaround
>> in net core may not be the right approach.
> It's hard to say who introduces this issue, we probably could point
> our finger to below commit
> bd869245a3dc net: core: try to runtime-resume detached device in __dev_open
> 
> This calling path is not usual, in my case, the NIC is not plugged in
> any Ethernet cable,
> and we are doing networking tests on another NIC on the system. So,
> remove the rtnl lock from igb driver will affect other scenarios.
> 
>>
>>> Jakub Kicinski <kuba@kernel.org> 於 2021年4月21日 週三 上午3:27寫道：
>>>>
>>>> On Tue, 20 Apr 2021 10:34:17 +0200 Eric Dumazet wrote:
>>>>> On Tue, Apr 20, 2021 at 9:54 AM AceLan Kao <acelan.kao@canonical.com> wrote:
>>>>>>
>>>>>> From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
>>>>>>
>>>>>> The rtnl_lock() has been called in rtnetlink_rcv_msg(), and then in
>>>>>> __dev_open() it calls pm_runtime_resume() to resume devices, and in
>>>>>> some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
>>>>>> again. That leads to a recursive lock.
>>>>>>
>>>>>> It should leave the devices' resume function to decide if they need to
>>>>>> call rtnl_lock()/rtnl_unlock(), so call rtnl_unlock() before calling
>>>>>> pm_runtime_resume() and then call rtnl_lock() after it in __dev_open().
>>>>>>
>>>>>>
>>>>>
>>>>> Hi Acelan
>>>>>
>>>>> When was the bugg added ?
>>>>> Please add a Fixes: tag
>>>>
>>>> For immediate cause probably:
>>>>
>>>> Fixes: 9474933caf21 ("igb: close/suspend race in netif_device_detach")
>>>>
>>>>> By doing so, you give more chances for reviewers to understand why the
>>>>> fix is not risky,
>>>>> and help stable teams work.
>>>>
>>>> IMO the driver lacks internal locking. Taking 看rtnl from resume is just
>>>> one example, git history shows many more places that lacked locking and
>>>> got papered over with rtnl here.
>>

You could alternatively try the following. It should avoid the deadlock,
and when runtime-resuming if __IGB_DOWN is set all we do is marking the
net_device as present (because of PCI D3 -> D0 transition).
I do basically the same in r8169 and it works as intended.

Disclaimer: I don't have an igb-driven device and therefore can't test
the proposal.

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 038a9fd1a..21436626a 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -9300,6 +9300,14 @@ static int __maybe_unused igb_runtime_suspend(struct device *dev)
 
 static int __maybe_unused igb_runtime_resume(struct device *dev)
 {
+	struct net_device *netdev = dev_get_drvdata(dev);
+	struct igb_adapter *adapter = netdev_priv(netdev);
+
+	if (test_bit(__IGB_DOWN, &adapter->state)) {
+		netif_device_attach(netdev);
+		return 0;
+	}
+
 	return igb_resume(dev);
 }
 
-- 
2.31.1

