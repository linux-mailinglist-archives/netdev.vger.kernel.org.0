Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD596263C0
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 22:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiKKVle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 16:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiKKVld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 16:41:33 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F89611C02
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:41:32 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id 21so9353896edv.3
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hdpRNRem5YVf176I9tuTqwkEF3UGGX7jqzwVZFfnxvI=;
        b=A1ejkEFsLKqFFbtRAM+Y8S9rc/P4vKsVJNzP7X35EEBOPfVqfaw6U7jWbYLCbnYI2d
         +ffFwP1kxre/dVfsuny5AJtkaiNWeZYNysIU+TbhebwcmHQ0cS/oUVzMzagcHzyeLUYQ
         ZFT9zEKxrXcC0aRaFG2w9aFmqty0hNKfxj4vVHgGon0vMt9iChy2cpHbMvKLAlk5kU3a
         KgwIAWP1wt1lB1zH2piFbkyVE4F5l8+AZw1/qtmUWZpSJiMGsmltm9ejpjYqrkYR2E23
         YiODXw6CgSUOKJ5ewgKietHp3o9r0VA4G/suxl3Ck8UwYEsIEnn6ilV5O+LLAu2rw7OA
         8J2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hdpRNRem5YVf176I9tuTqwkEF3UGGX7jqzwVZFfnxvI=;
        b=kBHbDzzM+0S8xv2JogXFB98avYGOM3HzbaCsFk9B+bF+Jkedt6GrDMV84+lapGJWNS
         gHc3aBQD4X4IDie3i4RTrJMie24pYozX1WjDwbu7JDpSpA79Fs/5hEz/n/7hlWC4YIsR
         dnQkOxpwtiGYcY6d6qIWZU+aGQN0L3ci3SemzInAZGuZbpG+5kfCSVWBnTT9m99jSrXD
         HUtxkvp2eNAqL4FuQc+aA4TQ6as+YZrZLY0/sLEaH9Si1Dq3IhkWDr4CFzPLR2sRNCZv
         JIU0dLpKdbdU11wad0JmHteTBEBn+VNBuhYLp9O1earsNy3canEfPoPgB79FM3RUt8hQ
         YeQg==
X-Gm-Message-State: ANoB5pmBrAWplI1drT/DUoXCJD1cjo3pswbC1d4vIzhNS1vL2z/pY5TX
        hDGeskQmgMYCSe+WeLqpPqU=
X-Google-Smtp-Source: AA0mqf5PYyILDjwhKy/fYL+hvhWIX2aStTIxLf0ObVRU7SRH6A3LCpqqT2KBleQbripbApP+5QKQag==
X-Received: by 2002:aa7:ce83:0:b0:457:23cb:20ab with SMTP id y3-20020aa7ce83000000b0045723cb20abmr3093204edv.254.1668202890432;
        Fri, 11 Nov 2022 13:41:30 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id u9-20020a170906068900b007ad9028d684sm1288171ejb.104.2022.11.11.13.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 13:41:29 -0800 (PST)
Date:   Fri, 11 Nov 2022 23:41:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, netdev@vger.kernel.org,
        Steffen =?utf-8?B?QsOkdHo=?= <steffen@innosonix.de>,
        Fabio Estevam <festevam@denx.de>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow hwstamping on the
 master port
Message-ID: <20221111214127.pzek6eonetzatc4a@skbuf>
References: <20221110124345.3901389-1-festevam@gmail.com>
 <20221110125322.c436jqyplxuzdvcl@skbuf>
 <CAOMZO5D9shR2WB+83UPOvs-CaRg7rmaZ-USokPu0K+jtvB2EYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5D9shR2WB+83UPOvs-CaRg7rmaZ-USokPu0K+jtvB2EYw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 08:13:56AM -0300, Fabio Estevam wrote:
> Hi Vladimir,
> 
> On Thu, Nov 10, 2022 at 9:53 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > NACK.
> >
> > Please extend dsa_master_ioctl() to "see through" the dp->ds->ops->port_hwtstamp_get()
> > pointer, similar to what dsa_port_can_configure_learning() does. Create
> > a fake struct ifreq, call port_hwtstamp_get(), see if it returned
> > -EOPNOTSUPP, and wrap that into a dsa_port_supports_hwtstamp() function,
> > and call that instead of the current simplistic checks for the function
> > pointers.
> 
> I tried to implement what you suggested in the attached patch, but I
> am not sure it is correct.
> 
> If it doesn't work, please cook a patch so we can try it.

Yeah, this is not what I meant. I posted a patch illustrating what I
meant here:
https://patchwork.kernel.org/project/netdevbpf/patch/20221111211020.543540-1-vladimir.oltean@nxp.com/
