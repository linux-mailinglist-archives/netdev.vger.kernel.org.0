Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77DE50D44A
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 20:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbiDXSzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 14:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiDXSze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 14:55:34 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE4A36B6C;
        Sun, 24 Apr 2022 11:52:31 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id x18so18044751wrc.0;
        Sun, 24 Apr 2022 11:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lReuseCvVNEXlTNL6o6EN+A35b6tYTj8OfIs+Kswr2w=;
        b=Q/lDeS27Mli6BRmeY0+ReefxtLnq4WxEwOUeT23rab46xj9eLTLuRI+y6emQa/uvJ3
         yifh02I+4aZKTF/Vy/urexsI9DOfBN6/Kj4U0Gx1K9JVqsaatT8Oi3amtqIn6ixWZiHv
         XF9M01eykb6CK6J27qfas0wtFodk89XkyCgvO1B6dTvnLtP3+SRjiIOyaBU762tRIgc0
         fxOA5ZUa80Z0V2zzMwxGYyG2MhhjWo/D/J4a4Y17sALe1ZZ6E8LBhd3SmPFxchcimHwo
         FaWsMtf8VdXiZuEc1jFR1kSCszoDsbFSMWMp8h0/wGkm9GWRG4HO+kArfHJJJKzcJHkY
         d4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lReuseCvVNEXlTNL6o6EN+A35b6tYTj8OfIs+Kswr2w=;
        b=DJHv4Il9wgVpj/XMgc5sLj9BlvtHhlAqlQaqubGZlbQsYwsDA+tVKGVIoTDUi0Pg32
         0Q84KRDYADus8OCM2cMaL5Ai7c+gqPNAsbV5pfo2CixxufNQRurAWCXiR69L6ZePVebR
         Bt0Yo86ME3R/QOSIG4gA7NzZqdNAKGHJe1luqs3x1ofHM9IeoslKXRzNizi0NMv7ytp6
         D/jXAO326uOGFzOydcY50DpBVffQ23buHOH76n5YQrQ5sopUHSkM/Lcyt+rLhO+zst7E
         sAVckSFoh7fR8uSkAq4OvgRQl3tYd0audjB/xQNfPvafpG2f8w3GRDaEuzfUOK0f9rgP
         /ElA==
X-Gm-Message-State: AOAM5313T6Ry7zM9OIxkX1459P5TwM2NYwT/Dh7yeq94EoMRJqHPgkWd
        TgqfmRMpVao62kcMhJrjI7c=
X-Google-Smtp-Source: ABdhPJzdSu+tOKnYLk2M4Bt2LpLZBmteIWBUSxTUVFX3oPW3/U02vyy5C9c3xv5wG+t2IljNl73spg==
X-Received: by 2002:a05:6000:381:b0:20a:8690:9ac6 with SMTP id u1-20020a056000038100b0020a86909ac6mr11485726wrf.209.1650826350182;
        Sun, 24 Apr 2022 11:52:30 -0700 (PDT)
Received: from [192.168.1.5] ([197.57.78.84])
        by smtp.gmail.com with ESMTPSA id a4-20020a056000188400b0020a9ec6e8e3sm7871526wri.55.2022.04.24.11.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 11:52:29 -0700 (PDT)
Message-ID: <06622e4c-b9a5-1c4f-2764-a72733000b4e@gmail.com>
Date:   Sun, 24 Apr 2022 20:52:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3 2/2] net: vxlan: vxlan_core.c: Add extack
 support to vxlan_fdb_delete
Content-Language: en-US
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     netdev@vger.kernel.org, outreachy@lists.linux.dev,
        roopa@nvidia.com, jdenham@redhat.com, sbrivio@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, shshaikh@marvell.com,
        manishc@marvell.com, razor@blackwall.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, GR-Linux-NIC-Dev@marvell.com,
        bridge@lists.linux-foundation.org
References: <cover.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
 <0d09ad611bb78b9113491007955f2211f3a06e82.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
 <alpine.DEB.2.22.394.2204241813210.7691@hadrien>
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
In-Reply-To: <alpine.DEB.2.22.394.2204241813210.7691@hadrien>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On ٢٤‏/٤‏/٢٠٢٢ ١٨:١٥, Julia Lawall wrote:
>
> On Sun, 24 Apr 2022, Alaa Mohamed wrote:
>
>> Add extack to vxlan_fdb_delete and vxlan_fdb_parse
> It could be helpful to say more about what adding extack support involves.
>
>> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
>> ---
>> changes in V2:
>> 	- fix spelling vxlan_fdb_delete
>> 	- add missing braces
>> 	- edit error message
>> ---
>> changes in V3:
>> 	fix errors reported by checkpatch.pl
> But your changes would seem to also be introducing more checkpatch errors,
> because the Linux kernel coding style puts a space before an { at the
> start of an if branch.
I ran checkpatch script before submitting this patch and got no error
>
> julia
>
>> ---
>>   drivers/net/vxlan/vxlan_core.c | 36 +++++++++++++++++++++++-----------
>>   1 file changed, 25 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
>> index cf2f60037340..4e1886655101 100644
>> --- a/drivers/net/vxlan/vxlan_core.c
>> +++ b/drivers/net/vxlan/vxlan_core.c
>> @@ -1129,19 +1129,23 @@ static void vxlan_fdb_dst_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
>>
>>   static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>>   			   union vxlan_addr *ip, __be16 *port, __be32 *src_vni,
>> -			   __be32 *vni, u32 *ifindex, u32 *nhid)
>> +			   __be32 *vni, u32 *ifindex, u32 *nhid, struct netlink_ext_ack *extack)
>>   {
>>   	struct net *net = dev_net(vxlan->dev);
>>   	int err;
>>
>>   	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
>> -	    tb[NDA_PORT]))
>> -		return -EINVAL;
>> +	    tb[NDA_PORT])){
>> +			NL_SET_ERR_MSG(extack, "DST, VNI, ifindex and port are mutually exclusive with NH_ID");
>> +			return -EINVAL;
>> +		}
>>
>>   	if (tb[NDA_DST]) {
>>   		err = vxlan_nla_get_addr(ip, tb[NDA_DST]);
>> -		if (err)
>> +		if (err){
>> +			NL_SET_ERR_MSG(extack, "Unsupported address family");
>>   			return err;
>> +		}
>>   	} else {
>>   		union vxlan_addr *remote = &vxlan->default_dst.remote_ip;
>>
>> @@ -1157,24 +1161,30 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>>   	}
>>
>>   	if (tb[NDA_PORT]) {
>> -		if (nla_len(tb[NDA_PORT]) != sizeof(__be16))
>> +		if (nla_len(tb[NDA_PORT]) != sizeof(__be16)){
>> +			NL_SET_ERR_MSG(extack, "Invalid vxlan port");
>>   			return -EINVAL;
>> +		}
>>   		*port = nla_get_be16(tb[NDA_PORT]);
>>   	} else {
>>   		*port = vxlan->cfg.dst_port;
>>   	}
>>
>>   	if (tb[NDA_VNI]) {
>> -		if (nla_len(tb[NDA_VNI]) != sizeof(u32))
>> +		if (nla_len(tb[NDA_VNI]) != sizeof(u32)){
>> +			NL_SET_ERR_MSG(extack, "Invalid vni");
>>   			return -EINVAL;
>> +		}
>>   		*vni = cpu_to_be32(nla_get_u32(tb[NDA_VNI]));
>>   	} else {
>>   		*vni = vxlan->default_dst.remote_vni;
>>   	}
>>
>>   	if (tb[NDA_SRC_VNI]) {
>> -		if (nla_len(tb[NDA_SRC_VNI]) != sizeof(u32))
>> +		if (nla_len(tb[NDA_SRC_VNI]) != sizeof(u32)){
>> +			NL_SET_ERR_MSG(extack, "Invalid src vni");
>>   			return -EINVAL;
>> +		}
>>   		*src_vni = cpu_to_be32(nla_get_u32(tb[NDA_SRC_VNI]));
>>   	} else {
>>   		*src_vni = vxlan->default_dst.remote_vni;
>> @@ -1183,12 +1193,16 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>>   	if (tb[NDA_IFINDEX]) {
>>   		struct net_device *tdev;
>>
>> -		if (nla_len(tb[NDA_IFINDEX]) != sizeof(u32))
>> +		if (nla_len(tb[NDA_IFINDEX]) != sizeof(u32)){
>> +			NL_SET_ERR_MSG(extack, "Invalid ifindex");
>>   			return -EINVAL;
>> +		}
>>   		*ifindex = nla_get_u32(tb[NDA_IFINDEX]);
>>   		tdev = __dev_get_by_index(net, *ifindex);
>> -		if (!tdev)
>> +		if (!tdev){
>> +			NL_SET_ERR_MSG(extack,"Device not found");
>>   			return -EADDRNOTAVAIL;
>> +		}
>>   	} else {
>>   		*ifindex = 0;
>>   	}
>> @@ -1226,7 +1240,7 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
>>   		return -EINVAL;
>>
>>   	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
>> -			      &nhid);
>> +			      &nhid, extack);
>>   	if (err)
>>   		return err;
>>
>> @@ -1291,7 +1305,7 @@ static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
>>   	int err;
>>
>>   	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
>> -			      &nhid);
>> +			      &nhid, extack);
>>   	if (err)
>>   		return err;
>>
>> --
>> 2.36.0
>>
>>
>>
