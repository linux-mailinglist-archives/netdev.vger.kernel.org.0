Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180056AEBC8
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 18:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjCGRtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 12:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbjCGRsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 12:48:35 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231EE8B07E
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 09:43:27 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id u9so55719471edd.2
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 09:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678211006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HY8B7YU0rEW4tU6YC9s+DFpVtZ1fIP0SQmfDEJb6rw4=;
        b=AHBuuLUIojVXuubRLzFW1rtPur4jbiV5G1ojGswQNQcVdyHL5vorPA71qEJKztwmnm
         ooTeIXBRahYY4wFdPt7k+cbQ7MpvH55krlXv60dhzlopJkzYq07a0Ja04zS/wLiBAbV0
         pp9lumPVSwUy2HfStFdxMpqV4NrcnRfpwSwKgnWwB2T1ZrxWbKY7MyPixHrUp06CoOkC
         yOtyM9oijwyS2N9K5cFshBuy4uiisnp279tWS87dIZlUy3LlFlxv8+rO/w1WYI0uZc3K
         6WIeRFijNbNrWb1ZL+pZSzDo/VPg58u+B6P3DoxWG3YXVRU18N4U/KMCg/8bIOi07dQc
         uRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678211006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HY8B7YU0rEW4tU6YC9s+DFpVtZ1fIP0SQmfDEJb6rw4=;
        b=y+pQV80haM0Be5yQzi4sWS1FfQW2pQqj9bqOnTgVpomAaLeMDR5AcvrSW5J6rjGRPq
         b0YhHrLQRuUteNg59O81G8ngJgGl4kTGSvz7Esu09GBJ/QCUdC9ZeQP+aho+ON77B4qe
         sivypoLrR0ojFYVs20W0t/pdTOEj/AMaKckE04qKZgLUkB14b2OV3bFldZN2hhqVMlQ0
         O2gxVk6P2B5OB0un3fxjgIdf7fwjm45CFpoWNDf8r5qtssDZJqGaplFMp3zLTZfm+Ztv
         zK/XVICCnfYR7Dv8elKMMtJJciXeXOS1ufNgPZbD8zXznLCU57RvJ06Rph17epEQoKVH
         jUcg==
X-Gm-Message-State: AO0yUKXRZxM01GSPQ7r/zCU9W97ZHxle6A552SvZYh6RMK3jStX+N67z
        RfpqjdxxdZeb6qcsy4reygM=
X-Google-Smtp-Source: AK7set/czagDFRW21AezUKb9CKMowwC08/rogZJzg2FTlTEtcf1GbdikMscNK3WrcE7wU7AOZUPJIg==
X-Received: by 2002:a17:906:dac3:b0:8a9:fa2f:e440 with SMTP id xi3-20020a170906dac300b008a9fa2fe440mr20239333ejb.55.1678211005710;
        Tue, 07 Mar 2023 09:43:25 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id h3-20020a170906590300b008ddf3476c75sm6436774ejq.92.2023.03.07.09.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 09:43:25 -0800 (PST)
Date:   Tue, 7 Mar 2023 19:43:23 +0200
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
Message-ID: <20230307174323.sbzhb7gy6blgj2jf@skbuf>
References: <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
 <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
 <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
 <20230228115846.4r2wuyhsccmrpdfh@skbuf>
 <CB415113-7581-475E-9BB9-48F6A8707C15@public-files.de>
 <20230228225622.yc42xlkrphx4gbdy@skbuf>
 <0842D2D2-E71C-4DEF-BBCD-2D0C0869046E@public-files.de>
 <20230301123743.qifnk34pqwuyhf7u@skbuf>
 <trinity-a6b4447d-52b8-42a6-a4ce-b06543872534-1678126825554@3c-app-gmx-bs54>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-a6b4447d-52b8-42a6-a4ce-b06543872534-1678126825554@3c-app-gmx-bs54>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 07:20:25PM +0100, Frank Wunderlich wrote:
> is it possible to map this function only to mt7530, not mt7531?
> 
> as one way i would add a check for the chip
> 
> if (priv->id != ID_MT7530) { return NULL; }
> //existing content for mt7531

yeah, returning "NULL" to ds->ops->preferred_default_local_cpu_port()
would mean "don't know, don't care" and DSA would choose by itself.

although I feel we're not at the stage where we should discuss about
that just yet.

> where did you find the comment about multicast?

well, I didn't find "link-local multicast", but "BPDU to CPU port" and
may have ran a little bit too far with that info.

If you search for the "Bridge Group Address" keyword in IEEE 802.1Q or
IEEE 802.1D (older) documents, you'll see that STP BPDUs are sent to a
reserved multicast MAC DA of 01-80-C2-00-00-00, which is link-local,
meaning that switches don't forward it but trap it. Since I knew that,
I just assumed that "BPDU to CPU port" means "trapping of any frames
with that MAC DA to the CPU port", since if I were a hardware designer,
that's what I would do. It's possible to identify STP BPDUs (to trap
just those) by examining the LLC header, but I wouldn't bother since the
MAC DA is reserved for this kind of stuff and I'd be locking myself out
of being compatible with possible protocol changes in the future.

> https://elixir.bootlin.com/linux/v6.3-rc1/source/drivers/net/dsa/mt7530.c has
> "multicast" only in the packet-counters (mib_desc)
> 
> > The next most obvious thing would be L2 PTP (ptp4l -2), but since mt7530
> > doesn't support hw timestamping, you'd need to try software timestamping
> > instead ("ptp4l -i swpX -2 -P -S -m", plus the equivalent command on a
> > link partner).
> 
> have not done anything with l2 p2p yet, and no server running...i'm not sure
> i can check this the right way.

Anyway, it doesn't have to be PTP, it can be literally any application
using a PF_PACKET socket to send sequence-numbered packets towards a
mt7530 port with the 01:80:c2:00:00:00 MAC DA, and using 2 tcpdump
instances on the 2 GMACs to check whether packets are received once or
twice.

If this is still too complicated, just send 5 actual BPDUs and see if
you receive them on both CPU ports:

mausezahn eth0 -b 01:80:c2:00:00:00 -c 5 -t bpdu
