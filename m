Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A784E5182
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 12:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243974AbiCWLok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 07:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243973AbiCWLoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 07:44:38 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79895E093;
        Wed, 23 Mar 2022 04:43:08 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 17so1447702lji.1;
        Wed, 23 Mar 2022 04:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=GUNacRM0Kzot4Ci3+9/rQiAP6HGdFO8cNfIKSh2/JpE=;
        b=Jdm0puZZ/Q6dFz353KCoDZvifEBG6tzHxW6igmTgxd+obwpPQAudDXwNknS/hhz/dn
         qCVif8Hnrp91CoRN93+vhhSXQr3O0aViX2rpkgbxco2CgKXm4vcj3xV/rB7waIx9ztsB
         R0mmMVc818zGQV6acVGBsI2XRGtQi23j0NZdJQ3tP5uOe3ghbIsHipM4baigfeZK+Sfz
         9sAsxvFUgiFl3NTSys9UjwoH0U+wR2PDNR7Z1KBKZCVkk4oU810jgtSTRDxyYTPoLCQd
         Dlvwu7iShS+Uf6N70yehFjkjjuL8gZFZjRNybtYbtHRcPvurxM4JhK/VMh4Hvuhcn2/e
         dgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GUNacRM0Kzot4Ci3+9/rQiAP6HGdFO8cNfIKSh2/JpE=;
        b=YBptG7s4kYIWcYn12GFL85yxSDWaaElDrVkuOh2sSrNU/CXA5YbS0gSZ7MfWlhctt8
         +FDGUfXATUZie9cSg211+vWBlBhd9pydc4hpFodKShlTT7+Z48o6BO7cx2wH0XnNi/V/
         KyRFPauHvlRnPtzP9tAAuCYoChHBLGscdZ2MvNHn0d0PqOATM7t/EINCDaubYAxndv23
         ypaE3hhUYVDBzXA/az35LagtVmB/ydYQSoIiIX5neeYelRcKRPZbFcsDmi8DbvTJCeT/
         D8f9w3jNAbp0wj5Skcg9GjKpV3FFjG7MWJLuL6UNCFsA0eTt1FkWdGm4z8qjBSEJmGdY
         Nijw==
X-Gm-Message-State: AOAM53395V6mVJIq7HKSE6Ri5Q7CkmAPXr7pGk7sBnqB4z7Ol2pTBLvi
        e3NeS/gSFUtMsrZ+IWLgTUpvblpdLu4vuw==
X-Google-Smtp-Source: ABdhPJykafU9a03wA5avbF9HT0x528x5zTqhH1AL31w9rXO/uO4pFDwD6bruH4dLIxrv5tOUpAMGvQ==
X-Received: by 2002:a2e:7d18:0:b0:247:f205:96fa with SMTP id y24-20020a2e7d18000000b00247f20596famr23072028ljc.269.1648035786533;
        Wed, 23 Mar 2022 04:43:06 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k2-20020a056512330200b0044a096ea7absm2008256lfe.54.2022.03.23.04.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 04:43:06 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20220323112116.q6shx2g4r23ungtc@skbuf>
References: <20220317172013.rhjvknre5w7mfmlo@skbuf>
 <86tubvk24r.fsf@gmail.com> <20220318121400.sdc4guu5m4auwoej@skbuf>
 <86pmmjieyl.fsf@gmail.com> <20220318131943.hc7z52beztqlzwfq@skbuf>
 <86a6dixnd2.fsf@gmail.com> <20220322110806.kbdb362jf6pbtqaf@skbuf>
 <86fsn90ye8.fsf@gmail.com> <20220323101643.kum3nuqctunakcfo@skbuf>
 <864k3p5437.fsf@gmail.com> <20220323112116.q6shx2g4r23ungtc@skbuf>
Date:   Wed, 23 Mar 2022 12:43:03 +0100
Message-ID: <86tuboao8o.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ons, mar 23, 2022 at 13:21, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Mar 23, 2022 at 11:57:16AM +0100, Hans Schultz wrote:
>> >> >> Another issue I see, is that there is a deadlock or similar issue when
>> >> >> receiving violations and running 'bridge fdb show' (it seemed that
>> >> >> member violations also caused this, but not sure yet...), as the unit
>> >> >> freezes, not to return...
>> >> >
>> >> > Have you enabled lockdep, debug atomic sleep, detect hung tasks, things
>> >> > like that?
>> >> 
>> >> I have now determined that it is the rtnl_lock() that causes the
>> >> "deadlock". The doit() in rtnetlink.c is under rtnl_lock() and is what
>> >> takes care of getting the fdb entries when running 'bridge fdb show'. In
>> >> principle there should be no problem with this, but I don't know if some
>> >> interrupt queue is getting jammed as they are blocked from rtnetlink.c?
>> >
>> > Sorry, I forgot to respond yesterday to this.
>> > By any chance do you maybe have an AB/BA lock inversion, where from the
>> > ATU interrupt handler you do mv88e6xxx_reg_lock() -> rtnl_lock(), while
>> > from the port_fdb_dump() handler you do rtnl_lock() -> mv88e6xxx_reg_lock()?
>> 
>> If I release the mv88e6xxx_reg_lock() before calling the handler, I need
>> to get it again for the mv88e6xxx_g1_atu_loadpurge() call at least. But
>> maybe the vtu_walk also needs the mv88e6xxx_reg_lock()?
>> I could also just release the mv88e6xxx_reg_lock() before the
>> call_switchdev_notifiers() call and reacquire it immediately after?
>
> The cleanest way to go about this would be to have the call_switchdev_notifiers()
> portion of the ATU interrupt handling at the very end of mv88e6xxx_g1_atu_prob_irq_thread_fn(),
> with no hardware access needed, and therefore no reg_lock() held.

So something like?
	mv88e6xxx_reg_unlock(chip);
	rtnl_lock();
	err = call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE, brport, &info.info, NULL);
	rtnl_unlock();
	mv88e6xxx_reg_lock(chip);
