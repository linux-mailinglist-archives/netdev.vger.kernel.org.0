Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEB663AB20
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiK1Ogs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiK1Ogr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:36:47 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164F7BC11;
        Mon, 28 Nov 2022 06:36:47 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ha10so26356767ejb.3;
        Mon, 28 Nov 2022 06:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e4ISe8StrCOcGj2m5mAlUonifufkb1z6SSvKNLqiIMs=;
        b=VexDcNokEuEO0yl29L47ZY45Ol8wdatJ5n9MpeRP3muD5IJbywClh4gyxfpO1KrzsL
         CjDILPSO3loMZbc2r1PTVBOeYpmIEkC//a3TdtLxVwyEXo/by4iuboThVaSklpOohcyw
         uHqixBUQrOoVLhhGJWrYeRF7I5J9y9NGI3lPtIIPGTwcF4XDHGfqG4nzXXi4F1DhsUqD
         dPfZAojNDJo0br8NcbzU5NjT6d1PtezXpzqWWey1y2EF2TQBPBo0sAa9BMlcloINCHr+
         fsv5W9K0OGzFDYZx9pXDf2OCP24oCiy/0jkPo6PBAUplrOSddh3On3N/497Rbiyx746E
         +Xnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4ISe8StrCOcGj2m5mAlUonifufkb1z6SSvKNLqiIMs=;
        b=YrIrBA1RTy18FtaCg7ZPNIbpYXzt27ZnZMIeHP5Njl+f+OT3m6jmV+WnsunGPd6JqS
         WfyK3pu9SrjiAXoBqu/WDMGky/KVuvuzph5PktX9e/m38y3AMmsd98NnNhpENURTro4q
         MPw5Vi6HSeeeJ4q88TKEHgjgedDcac/vLmK+dTSajqycIDW4lBpUBhLS3r1NEcWnWZ/M
         kQYqZ9QJEsAsCgV3rrgnG7W0NolT+76TATDPSzCkUM8XpqFp0TTIRV4hzKHd3fDw/Abp
         BGHCoHI5bLjAsSd3xPQiNoEniU1tYV/j0rvCysOI2JNPVfzcxJs2n2S7t5nEvxKpOUjp
         3BGQ==
X-Gm-Message-State: ANoB5pmgqBKWcfRl4IX0p4H4vsd8FC2bebuSEWuXs5vhgdPPsTIdaoro
        n7I/DO1Xsk9/Ts0nHCudFqY=
X-Google-Smtp-Source: AA0mqf42cvk5Fhccpof1Z+Dmms2gvN5uvduTqmGCSEqJZ3unph5p55yxQVgTjBnqZ1aYV4UeF6DreQ==
X-Received: by 2002:a17:906:f6c6:b0:78d:b367:20c1 with SMTP id jo6-20020a170906f6c600b0078db36720c1mr41386821ejb.530.1669646205650;
        Mon, 28 Nov 2022 06:36:45 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id a14-20020aa7d90e000000b004611c230bd0sm5247213edr.37.2022.11.28.06.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 06:36:45 -0800 (PST)
Date:   Mon, 28 Nov 2022 17:36:41 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: uninitialized variable in
 bond_miimon_inspect()
Message-ID: <Y4THeSrc0lOJP/AJ@kadam>
References: <Y4SWJlh3ohJ6EPTL@kili>
 <CALs4sv3xJXJvWwcGk8N_s1mW9Y7GpEz6Bqv-DJO_q7hPi2yTLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALs4sv3xJXJvWwcGk8N_s1mW9Y7GpEz6Bqv-DJO_q7hPi2yTLA@mail.gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 07:15:39PM +0530, Pavan Chebbi wrote:
> On Mon, Nov 28, 2022 at 4:36 PM Dan Carpenter <error27@gmail.com> wrote:
> >
> > The "ignore_updelay" variable needs to be initialized to false.
> >
> > Fixes: f8a65ab2f3ff ("bonding: fix link recovery in mode 2 when updelay is nonzero")
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > ---
> > v2: Re-order so the declarations are in reverse Christmas tree order
> >
> Thanks,
> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> 
> > Don't forget about:
> > drivers/net/bonding/bond_main.c:5071 bond_update_slave_arr() warn: missing error code here? 'bond_3ad_get_active_agg_info()' failed. 'ret' = '0'
> >
> 
> I think that warning can be ignored, as bond_update_slave_arr() does
> consider the return value of bond_3ad_get_active_agg_info() but
> chooses to not bubble it up. Though the author of the function is the
> best person to answer it, at this point, it looks OK to me. Maybe a
> separate patch to address it would help to get the attention of the
> author.

Heh...  That's slightly vague.

You're wrong to say that none of the callers care about the error code.
It is checked in bond_slave_arr_handler().

regards,
dan carpenter
