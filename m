Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23BA6E31A6
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 15:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjDONqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 09:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjDONqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 09:46:11 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8251BE8
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 06:46:08 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-5068e99960fso624172a12.1
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 06:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681566367; x=1684158367;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e/LGBXlZndjLK+YGrBMBLiOoJtgsY2TLp+3XJ6CSzVo=;
        b=rzG8Wf1mWLpIfuxG0IDmoHWFZoBT7IrnewqBFgg4JB0Jwoi8bS0jbDCwLz2lUgtVFr
         Mnb6U4KGX4kAI79tAS/igsjXRHEYXXA/Nob0Hl+VNHw6KUZRBIEff0b/jxePyz0rMV/v
         9bbTj2BxULG9xh7T8zP0g76oB8OkioRGJadkP0f2O8WaP7FxEXvHUp5PkLuZJfSNR3vL
         +1T7zk9EnS8K/V44FA5bR3dDJPbrZbXdbQeHdMPSjifhOmnyvxhGQ7RQugThW30OO8ar
         zLoD8Esgr3hfbOXq9qn1hcdTfCTEqN+WciM7ZkAKl2t9g8hjCl16D3Xz3mltwVfspxq7
         I7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681566367; x=1684158367;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e/LGBXlZndjLK+YGrBMBLiOoJtgsY2TLp+3XJ6CSzVo=;
        b=iuAMCjIGDdGfpbZ+OOmdMLu7LE1UPJHCULDSA+zPSPLKto7VIEnIHm+YJwNNCzjLzR
         ZXsPEB50KxAUrnnMpgN7q36SRbXBgNfpJEqQjBwYttLDhm+gs11i//NArDgp3PgjoPO8
         ZTlMD8IWv7+l4Hll3jt3W74OrwXTvx0V/HdfmIPKvd+awJ6SxV5JraNeqV7ihWafSWoE
         tjvAZfkSHeWzqT50CFt7R8n0AxRg6K/uK4ZNc9EBE6IBlAavYpvbLMRngAp5VW5cT83+
         M6kssg884uSK+2ouTD3dvTtOd6HTj1Rs+gKaKhlWQE+J3g5+FEE318fInf/QO7ovm+6/
         8nGQ==
X-Gm-Message-State: AAQBX9dhnwK6F7UPF3r58IonUeC+QaAvFSMuXU8D4ZRClLqz4o0Cpvvv
        cSx6+0ZjvulRWPgEYcOebcg=
X-Google-Smtp-Source: AKy350ZEclBgay4Wfk9Gc5qCnhzkCkZnLT6gJfilgqZrxSxGvg7YCHAVq/qzHvyjSYOUcoZxniPkoQ==
X-Received: by 2002:aa7:de0f:0:b0:506:965f:c8cf with SMTP id h15-20020aa7de0f000000b00506965fc8cfmr936502edv.34.1681566366673;
        Sat, 15 Apr 2023 06:46:06 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id i17-20020aa7c9d1000000b005065141d1f4sm3323401edt.20.2023.04.15.06.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 06:46:06 -0700 (PDT)
Date:   Sat, 15 Apr 2023 16:46:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Thibaut <hacks@slashdirt.org>
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
Message-ID: <20230415134604.2mw3iodnrd2savs3@skbuf>
References: <ZDnYSVWTUe5NCd1w@makrotopia.org>
 <e10aa146-c307-8a14-3842-ae50ceabf8cc@arinc9.com>
 <ZDnnjcG5uR9gQrUb@makrotopia.org>
 <5e10f823-88f1-053a-d691-6bc900bd85a6@arinc9.com>
 <ZDn1QabUsyZj6J0M@makrotopia.org>
 <01fe9c85-f1e0-107a-6fb7-e643fb76544e@arinc9.com>
 <ZDqb9zrxaZywP5QZ@makrotopia.org>
 <9284c5c0-3295-92a5-eccc-a7b3080f8915@arinc9.com>
 <20230415133813.d4et4oet53ifg2gi@skbuf>
 <5f7d58ba-60c8-f635-a06d-a041588f64da@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f7d58ba-60c8-f635-a06d-a041588f64da@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 04:40:19PM +0300, Arınç ÜNAL wrote:
> My wording was not great there. What I meant is that PHY muxing will be
> configured before dsa_register_switch() is run.

And we're back to the discussion from the thread "Move MT7530 phy muxing
from DSA to PHY driver". What if someone decides that they don't need
the switch driver - can they disable it? No.

Your thoughts are stopping mid way. If you think that PHY muxing should
work without registering the DSA switch, then it doesn't belong in the
DSA driver, plain and simple. No "yeah, but I can move it here, and it
could kinda work, as a side effect of a driver failing to probe, or
probing successfully but not registering with the subsystems for its
primary purpose, or ...".
