Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0786A62EB
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjB1W4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjB1W4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:56:33 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E35B1287D
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 14:56:27 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id o15so44106334edr.13
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 14:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EEEhrFfApSxeV7Wl+zd9RXP+32Gm8xjWCyUqDpeveUM=;
        b=C5gT6igu/1KikDE9Rw/UaAZGFfcKptFzwlXCFzxrTSkivbrmEA8VUMgIS8kkzVEu66
         5lmNpRcfxT+p+P+L8w1PPvPX4knbiPhiEP98TR5jgDGJ7ZR4UXfrf8IrGtJKQ1jsZgX5
         eXXQM34NM5JYx3zJzaNB3Pw5SwJZntM8cnyVoNETEI6HR/fkkaleZ1opiEEdz5jmj/Ag
         BSCRPiIMaKtyI6gooEcKKz30qenD/4Ozjo4AI9Owr6HI2/ajN82gqNuylQFMiqBsujph
         RZsEIp0z21IiyM5njMOVrPmJqPk98RSh4mlD0unEoLa613a8RpOjVXidUVRTBkcLHDIr
         KEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EEEhrFfApSxeV7Wl+zd9RXP+32Gm8xjWCyUqDpeveUM=;
        b=SXxJ/D6xzUT92rrvVl+/z0IdvUsX5UXeejkDVd6jiwj5cq8OpI+c6/6nWhQKasnYi/
         seaGsDtHH67WZwB754cB7cvDXfyYpeLN14vX3az5tdpA5j+XnfFNKz0MjdeJ09DXsN+E
         alsabj7BByq+6RoRp6qCvkzjLQoZ4FokwWehEvrtRMMaFrtyFHeR6qb7vuz3GO8rTtpr
         Viq/ZiAi8zn+vmDlOxzFZRtojZ2k10kHuCDOgq34peyCnDgSz0BshWPENze1fLXmP0n2
         MZcNImpLZWj1l/Jv8YJgSi8H6wjRzGZNsx5ZcxLP8gsCk6ZOeMEU6stplco/ne75uK0w
         +EUQ==
X-Gm-Message-State: AO0yUKXHJnMrs01E7g9XJrdx8LCSrsurynDpfh9JPlJISNxizJzZ2anV
        5RectYYJscypRLoKFzvHmyTiqybc3f8fKQ==
X-Google-Smtp-Source: AK7set8udoU9YmO2lquZe4Trd2KRAZy0RQ+fpQmt2y7ds7uDQn1X/AbK3qykYkoC3vZHKKfU0Ub4kA==
X-Received: by 2002:a17:906:10c8:b0:8af:ef00:b853 with SMTP id v8-20020a17090610c800b008afef00b853mr4119759ejv.73.1677624985610;
        Tue, 28 Feb 2023 14:56:25 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id qq10-20020a17090720ca00b008e09deb6610sm4936115ejb.200.2023.02.28.14.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 14:56:25 -0800 (PST)
Date:   Wed, 1 Mar 2023 00:56:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Felix Fietkau <nbd@nbd.name>, netdev <netdev@vger.kernel.org>,
        erkin.bozoglu@xeront.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230228225622.yc42xlkrphx4gbdy@skbuf>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
 <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
 <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
 <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
 <20230228115846.4r2wuyhsccmrpdfh@skbuf>
 <CB415113-7581-475E-9BB9-48F6A8707C15@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CB415113-7581-475E-9BB9-48F6A8707C15@public-files.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 02:48:13PM +0100, Frank Wunderlich wrote:
> I have only this datasheet from bpi for mt7531
> 
> https://drive.google.com/file/d/1aVdQz3rbKWjkvdga8-LQ-VFXjmHR8yf9/view
> 
> On page 23 the register is defined but without additional information
> about setting multiple bits in this range. CFC IS CPU_FORWARD_CONTROL
> register and CPU_PMAP is a 8bit part of it which have a bit for
> selecting each port as cpu-port (0-7). I found no information about
> packets sent over both cpu-ports, round-robin or something else.
> 
> For mt7530 i have no such document.

I did have the document you shared and did read that description.
I was asking for the results of some experiments because the description
isn't clear, and characterizing the impact it has seems like a more
practical way to find out.

> The way i got from mtk some time ago was using a vlan_aware bridge for
> selecting a "cpu-port" for a specific user-port. At this point port5
> was no cpu-port and traffic is directly routed to this port bypassing
> dsa and the cpu-port define in driver...afaik this way port5 was
> handled as userport too.

Sorry, I understood nothing from this. Can you rephrase?
