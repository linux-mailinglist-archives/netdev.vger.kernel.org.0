Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1103C4C986B
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 23:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbiCAWhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 17:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiCAWhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 17:37:33 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010803D1EF
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 14:36:50 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id f37so29288981lfv.8
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 14:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=Zv6CzkwCvG/NugMdcQPdvaaqMzdmpyxlpoMQJY68p2I=;
        b=2Fw39YIQ7LDHPMnZmMfl++mBc7woUGhPpxozViAJQlqiBBRTeVxvzlDjhJLBdlBYb/
         RIF1lA44WgNr+8eYLS20ydM8fIjT9RnvBoULi7wRYtyICBPHuz8MbFw6Ke4zTSvq1+15
         pTtghScX5FbbBTrCZHdXq046+ooB3R9s8H4BqqftfACXer2FvZAogvXOYsGWAzVG5HPW
         UGleeFx4P0hTbxg9Aim5FCJDJuUEKD7vt2s5EGHwnaFktl2N8DRgzCsCliW1ep5cgz5a
         bao1RK6a+FG1hY+6t4MRDtIQluECuCLcoDCAT6BDVNW2dyr7ylKtXehguweykTkAzz3F
         N1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=Zv6CzkwCvG/NugMdcQPdvaaqMzdmpyxlpoMQJY68p2I=;
        b=S79RtheUWR19vF3bwhr/mRzvRDa63Je4hUx2YBrqgHdJSYc5agscQTghGPfc+HgvqA
         31WptUxexlNVS+d0Zwal+rwm36rl6Lt8woBd9qqz8RazukZGOh1Ek2OMOFaJuyPEkkry
         5aXJ7d7QxwWF8DVzAxL+H2YCE47uAfdh34WmtlNm/2vaBv/m2cWnQMbsiuZ3WMwo96aM
         gV0qkOCDmdpCZeeAUukiHdyGRlDOMNFqrzQufarlNKr61xDBwH6WeISbwmaLvRfc8QCh
         JfQXi8jToUzGm51mXBWfgHGmD6HpCHbnTSVWlX/O51ZJ8XwE4xWHLdkIGsN6xqd1YlvV
         gGSw==
X-Gm-Message-State: AOAM532fNHyJ9WndezLMs/GrypnhG0+0qo0QC62fXDwBiPkH6SadoY1h
        h1uaeYvvM2HgCji/M0BSmp0LaA==
X-Google-Smtp-Source: ABdhPJy42Ub3CJMe+VY5HohnNHapyZvk6wJBXYVRTDJs2PSp51mQk4G+S3z+lpy7wt8lXsMoUrVpuQ==
X-Received: by 2002:ac2:4436:0:b0:435:e385:8791 with SMTP id w22-20020ac24436000000b00435e3858791mr16829159lfl.291.1646174208070;
        Tue, 01 Mar 2022 14:36:48 -0800 (PST)
Received: from [127.0.0.1] ([213.239.67.158])
        by smtp.gmail.com with ESMTPSA id u9-20020ac251c9000000b004433152750bsm1692648lfm.213.2022.03.01.14.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 14:36:47 -0800 (PST)
Date:   Tue, 01 Mar 2022 23:36:43 +0100
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Ido Schimmel <idosch@idosch.org>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
CC:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: Re: [PATCH 1/3] net: bridge: Implement bridge flag local_receive
User-Agent: K-9 Mail for Android
In-Reply-To: <Yh5NL1SY7+3rLW5O@shredder>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com> <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com> <Yh5NL1SY7+3rLW5O@shredder>
Message-ID: <EE0F5EE3-C6EA-4618-BBA2-3527C7DB88B4@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1 March 2022 17:43:27 CET, Ido Schimmel <idosch@idosch=2Eorg> wrote:
>On Tue, Mar 01, 2022 at 01:31:02PM +0100, Mattias Forsblad wrote:
>> This patch implements the bridge flag local_receive=2E When this
>> flag is cleared packets received on bridge ports will not be forwarded =
up=2E
>> This makes is possible to only forward traffic between the port members
>> of the bridge=2E
>>=20
>> Signed-off-by: Mattias Forsblad <mattias=2Eforsblad+netdev@gmail=2Ecom>
>> ---
>>  include/linux/if_bridge=2Eh      |  6 ++++++
>>  include/net/switchdev=2Eh        |  2 ++
>
>Nik might ask you to split the offload part from the bridge
>implementation=2E Please wait for his feedback as he might be AFK right
>now
>

Indeed, I'm traveling and won't have pc access until end of week (Sun)=2E=
=20
I'll try to review the patches through my phoneas much as I can=2E
Ack on the split=2E

>>  include/uapi/linux/if_bridge=2Eh |  1 +
>>  include/uapi/linux/if_link=2Eh   |  1 +
>>  net/bridge/br=2Ec                | 18 ++++++++++++++++++
>>  net/bridge/br_device=2Ec         |  1 +
>>  net/bridge/br_input=2Ec          |  3 +++
>>  net/bridge/br_ioctl=2Ec          |  1 +
>>  net/bridge/br_netlink=2Ec        | 14 +++++++++++++-
>>  net/bridge/br_private=2Eh        |  2 ++
>>  net/bridge/br_sysfs_br=2Ec       | 23 +++++++++++++++++++++++
>
>I believe the bridge doesn't implement sysfs for new attributes
>

Right, no new sysfs please=2E

>>  net/bridge/br_vlan=2Ec           |  8 ++++++++
>>  12 files changed, 79 insertions(+), 1 deletion(-)
>
>[=2E=2E=2E]
>
>> diff --git a/net/bridge/br_input=2Ec b/net/bridge/br_input=2Ec
>> index e0c13fcc50ed=2E=2E5864b61157d3 100644
>> --- a/net/bridge/br_input=2Ec
>> +++ b/net/bridge/br_input=2Ec
>> @@ -163,6 +163,9 @@ int br_handle_frame_finish(struct net *net, struct =
sock *sk, struct sk_buff *skb
>>  		break;
>>  	}
>> =20
>> +	if (local_rcv && !br_opt_get(br, BROPT_LOCAL_RECEIVE))
>> +		local_rcv =3D false;
>> +
>
>I don't think the description in the commit message is accurate:
>"packets received on bridge ports will not be forwarded up"=2E From the
>code it seems that if packets hit a local FDB entry, then they will be
>"forwarded up"=2E Instead, it seems that packets will not be flooded
>towards the bridge=2E In which case, why not maintain the same granularit=
y
>we have for the rest of the ports and split this into unicast /
>multicast / broadcast?
>

Exactly my first thought - why not implement the same control for the brid=
ge?
Also try to minimize the fast-path hit, you can keep the needed changes=20
localized only to the cases where they are needed=2E
I'll send a few more comments in a reply to the patch=2E

>BTW, while the patch honors local FDB entries, it overrides host MDB
>entries which seems wrong / inconsistent=2E
>
>>  	if (dst) {
>>  		unsigned long now =3D jiffies;

