Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C269D640215
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbiLBI36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiLBI3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:29:11 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80AE13E37
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:26:38 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a16so5482909edb.9
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 00:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ML3LigPye9slymmQTT1udRKE8+nSaEiNw/uG2E2KoPk=;
        b=R2E00+wpZOyDrFOmsvkiQhyX0vhYiWQxk0xBVNl8ZEIvllE3rxhNKOIAvHiwPrNuhM
         e69lNIdquVuJygverzP60tvyr7iAsfXbU/f0vM4XiRUBX9pcGUBPq3FxSFaSSJLNsmPG
         l7erayyPpaiOKeBkuDLBSKiEW45Ang/X/09t82O7maW6UKL49lUqOJOLL8wxp1Axyk7b
         8JuV8qgMM+q/f7tkm4M2ck5h9ncSHhaMyrE/3DoHtM4WhB6ziELdfDbXwgrID1MKiRUh
         mP1Nf9Wucb5AfEZM99XQ5MLuvvHhAFwK4sF19IWVZEs4CEZAVckn6A1kXmeOcFj+kVeH
         m6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ML3LigPye9slymmQTT1udRKE8+nSaEiNw/uG2E2KoPk=;
        b=w2jXQ6gqkvMDjHs8haylCXuBjCY9NkW8pE7VgcWUHmoQSDcPXuD2HILb6ViTBjs+gc
         07b2Pc3n8epeIZcjj3Lolh1MbNriHy54wLiZDJAl6zwlwkcncXuo28NAGsrPefp+7vTG
         vRnP1DA2C2JxGEwBbtUYe5yYadx6EDKnegCk//ZqdLVNidulQPpGLXOBMTNCK8FDdTG1
         jdFIxCx9mVhHvkafQncXuMQlwetT6HB4DD27v+vwnsvMjkhxa009kNbwDvODTkeV8/hK
         P0N9XxMxotbD7+rtdVjYx0jAKak4kkeKOrwHmSX8/X08OebCPBrWdQXDrqP0su/mEMca
         tE4w==
X-Gm-Message-State: ANoB5pmePJJI+GFAv3YbLZatBD7R+8kOWrYmikDY91hE/tdmGYnYXe49
        vQlyKXKAKqSvjTEw+GGVJG/YnehSgaDoYZH/
X-Google-Smtp-Source: AA0mqf7VBGh4BsMl5rZuxBaltmb88R5RTrFason69vnJzqsb+Dye6NCzNT7f5Snl8A4Uu5eIUmjKcQ==
X-Received: by 2002:a05:6402:2998:b0:46c:5e:9f89 with SMTP id eq24-20020a056402299800b0046c005e9f89mr4957763edb.259.1669969597231;
        Fri, 02 Dec 2022 00:26:37 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id h26-20020a1709063b5a00b0078db5bddd9csm2208295ejf.22.2022.12.02.00.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 00:26:36 -0800 (PST)
Date:   Fri, 2 Dec 2022 09:26:42 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, peppe.cavallaro@st.com,
        Voon Weifeng <weifeng.voon@intel.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Antonio Borneo <antonio.borneo@st.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net] stmmac: fix potential division by 0
Message-ID: <Y4m2wg+OFc7pHc/7@gvm01>
References: <Y4f3NGAZ2rqHkjWV@gvm01>
 <Y4gFt9GBRyv3kl2Y@lunn.ch>
 <Y4iA6mwSaZw+PKHZ@gvm01>
 <Y4i/Aeqh94ZP/mA0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4i/Aeqh94ZP/mA0@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 03:49:37PM +0100, Andrew Lunn wrote:
> On Thu, Dec 01, 2022 at 11:24:42AM +0100, Piergiorgio Beruto wrote:
> > On Thu, Dec 01, 2022 at 02:39:03AM +0100, Andrew Lunn wrote:
> > > On Thu, Dec 01, 2022 at 01:37:08AM +0100, Piergiorgio Beruto wrote:
> > > > Depending on the HW platform and configuration, the
> > > > stmmac_config_sub_second_increment() function may return 0 in the
> > > > sec_inc variable. Therefore, the subsequent div_u64 operation can Oops
> > > > the kernel because of the divisor being 0.
> > > 
> > > I'm wondering why it would return 0? Is the configuration actually
> > > invalid? Is ptp_clock is too small, such that the value of data is
> > > bigger than 255, but when masked with 0xff it gives zero?
> > Ok, I did some more analysis on this. On my reference board, I got two
> > PHYs connected to two stmmac, one is 1000BASE-T, the other one is
> > 10BASE-T1S.
> > 
> > Fot the 1000BASE-T PHY everything works ok. The ptp_clock is 0ee6b280
> > which gives data = 8 that is less than FF.
> > 
> > For the 10BASE-T1 PHY the ptp_clock is 001dcd65 which gives data = 400
> > (too large). Therefore, it is 0 after masking.
> 
> So both too large, and also unlucky. If it had been 0x3ff you would
> not of noticed.
> 
> > The root cause is the MAC using the internal clock as a PTP reference
> > (default), which should be allowed since the connection to an external
> > PTP clock is optional from an HW perspective. The internal clock seems
> > to be derived from the MII clock speed, which is 2.5 MHz at 10 Mb/s.
> 
> I think we need help from somebody who understands PTP on this device.
> The clock is clearly out of range, but how important is that to PTP?
> Will PTP work if the value is clamped to 0xff? Or should we be
> returning -EINVAL and disabling PTP because it has no chance of
> working?
> 
> Add to Cc: a few people who have worked on the PTP code. Lets see what
> they have to say.
> 
>      Andrew

For reference, this is the log of the error.

/root # ifconfig eth0 up
[   95.062067] socfpga-dwmac ff700000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
[   95.076440] socfpga-dwmac ff700000.ethernet eth0: PHY [stmmac-0:08] driver [NCN26000] (irq=49)
[   95.095964] dwmac1000: Master AXI performs any burst length
[   95.101588] socfpga-dwmac ff700000.ethernet eth0: No Safety Features support found
[   95.109428] Division by zero in kernel.
[   95.113447] CPU: 0 PID: 239 Comm: ifconfig Not tainted 6.1.0-rc7-centurion3-1.0.3.0-01574-gb624218205b7-dirty #77
[   95.123686] Hardware name: Altera SOCFPGA
[   95.127695]  unwind_backtrace from show_stack+0x10/0x14
[   95.132938]  show_stack from dump_stack_lvl+0x40/0x4c
[   95.137992]  dump_stack_lvl from Ldiv0+0x8/0x10
[   95.142527]  Ldiv0 from __aeabi_uidivmod+0x8/0x18
[   95.147232]  __aeabi_uidivmod from div_u64_rem+0x1c/0x40
[   95.152552]  div_u64_rem from stmmac_init_tstamp_counter+0xd0/0x164
[   95.158826]  stmmac_init_tstamp_counter from stmmac_hw_setup+0x430/0xf00
[   95.165533]  stmmac_hw_setup from __stmmac_open+0x214/0x2d4
[   95.171117]  __stmmac_open from stmmac_open+0x30/0x44
[   95.176182]  stmmac_open from __dev_open+0x11c/0x134
[   95.181172]  __dev_open from __dev_change_flags+0x168/0x17c
[   95.186750]  __dev_change_flags from dev_change_flags+0x14/0x50
[   95.192662]  dev_change_flags from devinet_ioctl+0x2b4/0x604
[   95.198321]  devinet_ioctl from inet_ioctl+0x1ec/0x214
[   95.203462]  inet_ioctl from sock_ioctl+0x14c/0x3c4
[   95.208354]  sock_ioctl from vfs_ioctl+0x20/0x38
[   95.212984]  vfs_ioctl from sys_ioctl+0x250/0x844
[   95.217691]  sys_ioctl from ret_fast_syscall+0x0/0x4c
[   95.222743] Exception stack(0xd0ee1fa8 to 0xd0ee1ff0)
[   95.227790] 1fa0:                   00574c4f be9aeca4 00000003 00008914 be9aeca4 be9aec50
[   95.235945] 1fc0: 00574c4f be9aeca4 0059f078 00000036 be9aee8c be9aef7a 00000015 00000000
[   95.244096] 1fe0: 005a01f0 be9aec38 004d7484 b6e67d74

   Piergiorgio
