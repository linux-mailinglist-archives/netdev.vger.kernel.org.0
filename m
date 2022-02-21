Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9628D4BE3C5
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381557AbiBURQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 12:16:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381547AbiBURPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 12:15:53 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF68A2611C;
        Mon, 21 Feb 2022 09:15:28 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id qx21so34885741ejb.13;
        Mon, 21 Feb 2022 09:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=m+8WxVJKLV9vdtzQXizjpfC8/kUaKUIJ+booSFAywZY=;
        b=BcT6iUZnuPYueg3xZ5n8aozdkj9N7qGQdZft1XHTMDCGD1TGUMNYaNgiYbR6vFiuxo
         YMOrACf2LGpykMtehZD0da+glV6bKXxhZLh7vQQAJ1PIkjSNkL7x6WmYeAnz5TII5PXf
         9dQNM9lx1WjTow+55VxDbfjydabrnnhg8tGu4lRbOccUu1GKM5fEpF2Q/HwEap/SCp47
         KgpELpvMtTdPjIb6AVK4ls8ftDNEiD3YMYtgAPKKZrzx/zUbnL6WQzNhYhO4UgndNXF3
         goKpvyqAyZDChyvk7R5yom+YGLvmQqTn9zQv/YUI5J1na/OP3Q+69oF5rw626PILMff1
         xAAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=m+8WxVJKLV9vdtzQXizjpfC8/kUaKUIJ+booSFAywZY=;
        b=wPlxWXicFJExzWATME3IlU3AONtiFCK8vZVgp9r7ktjqKuxgqzToU6nr0js+pIhgmm
         IvtF9L6y7ghRtQH83onC009cnwcp11QMY3Kf/FhXqF/1Gxbs63o87wtEG/M2DcMvf7MD
         tMOXYhyuvf083IQj1KXImC4OPNAVm47yWk4B0o0jbybHTGzXowZiTCCBWf7l79q2voWA
         2QYRMZ64mL2kkShoL4J9KyYoYAS+lT9ztLzYYgaZFe/eDa9ViPEfG1lKvy8XEjOw3DaA
         /OSGvhqC0ThkiwqhB0MltSrzunYP8olyRNOUxwAUNk0vhVOZxZ5f/XqhAbzJbD6W6wIy
         RwCw==
X-Gm-Message-State: AOAM532QinjmTySvlbzb9bEijOaZpSPN84EAD1k0rYkbdZX5cR+1FZ3K
        vMepFZ+kB4pUHFmIfSW8WLU=
X-Google-Smtp-Source: ABdhPJxgv7yZ92FDt5en40uAduIvsvGWzaPDIGt2croYEOXJ7mUM2uZ8HiI6VGLjT/dXO6Gn9xP13w==
X-Received: by 2002:a17:906:53d2:b0:6ce:791a:31a0 with SMTP id p18-20020a17090653d200b006ce791a31a0mr16599021ejo.59.1645463727294;
        Mon, 21 Feb 2022 09:15:27 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id k7sm5263349ejp.182.2022.02.21.09.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 09:15:26 -0800 (PST)
Date:   Mon, 21 Feb 2022 19:15:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
Message-ID: <20220221171525.ib32ghevud4745hz@skbuf>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
 <20220216160500.2341255-3-alvin@pqrs.dk>
 <20220216233906.5dh67olhgfz7ji6o@skbuf>
 <874k4yrlcj.fsf@bang-olufsen.dk>
 <20220217111709.x5g6alnhz3njo4t2@skbuf>
 <87bkz5r6zq.fsf@bang-olufsen.dk>
 <871qzwjmtv.fsf@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871qzwjmtv.fsf@bang-olufsen.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alvin,

On Mon, Feb 21, 2022 at 02:50:24PM +0000, Alvin Šipraga wrote:
> So I made a test module which, in summary, checks the following:
> 
> 1. for PHY reads, at what point does inserting a stray register access
>    (either read or write) cause the PHY read to fail?
> 2. for PHY writes, can stray register access also cause failure?
> 2. for MIB reads, can stray register access also cause failure?
> 
> For (1) I instrumented the PHY indirect access functions in the 6
> possible places where spurious register access could occur. Of those 6
> locations for spurious register access, 4 have no effect: you can put a
> read or write to an unrelated register there and the PHY read will
> always succeed. I tested this with spurious access to nearly every
> available register on the switch.
> 
> However, for two locations of spurious register access, the PHY read
> _always_ fails. The locations are marked /* XXX */ below:
> 
> /* Simplified for brevity */
> static int rtl8365mb_phy_ocp_read(struct realtek_priv *priv, int phy,
> 				  u32 ocp_addr, u16 *data)
> {
> 	rtl8365mb_phy_poll_busy(priv);
> 
> 	rtl8365mb_phy_ocp_prepare(priv, phy, ocp_addr);
> 
> 	/* Execute read operation */
> 	regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_CTRL_REG, val);
> 
> 	/* XXX */
> 
> 	rtl8365mb_phy_poll_busy(priv);
> 
> 	/* XXX */
> 
> 	/* Get PHY register data */
> 	regmap_read(priv->map, RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG,
> 		    &val);
> 
> 	*data = val & 0xFFFF;
> 
> 	return 0;
> }
> 
> In the case of a spurious read, the result of that read then poisons the
> ongoing PHY read, as suggested before. Again I verified that this is
> always the case, for each available register on the switch. Spurious
> writes also cause failure, and in the same locations too. I did not
> investigate whether the value written is then read back as part of the
> PHY read.
> 
> For (2) I did something similar to (1), but the difference here is that
> I could never get PHY writes to fail. Admittedly not all bits of the PHY
> registers tend to be writable, but for those bits that were writable, I
> would always then read back what I had written.
> 
> For (3) I did something similar to (1), and as claimed previously, this
> never resulted in a read failure. Here I had to use the MIB counters of
> a disconnected port so that I could assume the values were always 0.
> 
> I have attached the test module (and header file generated from an
> enormous header file from the Realtek driver sources, so that I could
> iterate over every possible register). It is pretty gruesome reading but
> gives me confidence in my earlier claims. The only refinements to those
> claims are:
> 
> - where _exactly_ a spurious register access will cause failure: see the
>   /* XXX */ in the code snippet upstairs;
> - PHY writes seem not to be affected at all.
> 
> Finally, I reached out to Realtek, and they confirmed pretty much the
> same as above. However, they claim it is not a hardware bug, but merely
> a property of the hardware design. Here I paraphrase what was said:
> 
> 1. Yes, spurious register access during PHY indirect access will cause
> the indirect access to fail. This is a result of the hardware design. In
> general, _if a read fails, the value read back will be the result of the
> last successful read_. This confirms the "register poisoning" described
> earlier.
> 
> 2. MIB access is a different story - this is table lookup, not indirect
> access. Table lookup is not affected by spurious register access.
> 
> 3. Other possible accesses - not currently present in this driver, but
> for which I have some WIP changes - include ACL (Access Control List),
> L2 (FDB), and MC (MDB) access. But all of these are table access similar
> to MIB access, and hence not troubled by spurious register access.
> 
> 4. HOWEVER, only one table can be accessed at a time. So a lock is
> needed here. Currently the only table lookup is MIB access, which is
> protected by mib_lock, so we are OK for now.
> 
> 5. It should be sufficient to lock during indirect PHY register access
> as prescribed in my patch.
> 
> I hope that clears things up. I will be sending a v2 with a revised
> description, including the statements from Realtek and the results of
> the tests I ran.
> 
> Kind regards,
> Alvin

Nice work!

This looks more comprehensive, although regarding check_phy_write(),
my understanding is that you checked cross-reads and cross-writes with
only one register: priv->read_reg is implicitly 0 during the
do_reg_work() -> check_phy_write() call sequence, so that register is
probably PORT0_CGST_HALF_CFG.

Anyway, if Realtek's description is that "if a read fails, the value
read back will be the result of the last successful read", then it's
probably not suprising that cross-reads and cross-writes don't make the
indirect PHY write fail (since there's no register read). I don't have
the background of what is the OCP, but the implication of the above
paragraph seems to be that an indirect PHY read is in essence the read
of a single register, which gets aborted when a read of any other
register except RTL8365MB_INDIRECT_ACCESS_STATUS_REG or
RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG gets initiated.
