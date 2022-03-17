Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1894DC8CB
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbiCQOcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiCQOcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:32:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5334216CE40
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647527454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LvBM59o6nV78OzR46Y/UGtG/GY/zmPgvrEl4fMRN7Ys=;
        b=WiOzZ/mPM3+zF78GEGyy9r4sW8gjBqS+7DTeiKUBvW3Yr45ysOm+xyAOi7S1dtWPXaGIUr
        1bKGHVtXofadluf5oua75GezZ0nSDF6+dyEg5D2OM2p6Tuef4CXXqLsADKCiRi2NWMmkJ2
        pwIbPROBQpi94kM9UYReK0VCvZbSEJM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-Y5QGU1uxMiabHXvlp02rzw-1; Thu, 17 Mar 2022 10:30:53 -0400
X-MC-Unique: Y5QGU1uxMiabHXvlp02rzw-1
Received: by mail-ej1-f71.google.com with SMTP id qf24-20020a1709077f1800b006ce8c140d3dso3014745ejc.18
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:30:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LvBM59o6nV78OzR46Y/UGtG/GY/zmPgvrEl4fMRN7Ys=;
        b=g9QuRIH3Q3Iq6x7L5q03MXS+pyglHiqLx9e1bg84OJbGlage8jTOoRiIsNunfeAPKw
         InbxFBEyhCp0PQg0jVnIUhuhc7rc1gOhYo3i8w28feq2BhTaSeXB7r7PnILmtCkXUyUc
         qXRAPM39zDX1oLKeOXxsM8yklJjEPZywOl92gV5bulqJ2g0+rbU+CmpZ+UB+e8aI9evZ
         c12CPm+jsXHJK/n/tKd8mSCUCVeCBQZ1MdWGkZMoj8da0NBcwtwx3eZHqu4LOtdLmCwI
         adIlvtpd81rwcohciNZ+Jp8GTbOJo1LBxGs4Uf7Ybfn1n/jOw8jlnXn7cF1A2l+ntQ+a
         5Kvw==
X-Gm-Message-State: AOAM530ZY+ZwetZfZQjyRdNYqwJfweucYSkJmAa3TZeU1UuBVxRgruVk
        fm1lXRUJ/wzfYugTqw2FsP1lel/WwxTh7eeA9/Xaqc8dqlOEmK9HYZcY5JLh+fmhTZzvyE1eieC
        lyHnLFfl/eQbcfdTb
X-Received: by 2002:a05:6402:354f:b0:416:8fba:8348 with SMTP id f15-20020a056402354f00b004168fba8348mr4830017edd.73.1647527451861;
        Thu, 17 Mar 2022 07:30:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwS9EVn7loogGixDXs6e8uxZ+0f5oQJfeOemsRQDbRXhBnKq/qW7shd/mxEy8ZRkBxHiKgruQ==
X-Received: by 2002:a05:6402:354f:b0:416:8fba:8348 with SMTP id f15-20020a056402354f00b004168fba8348mr4829978edd.73.1647527451561;
        Thu, 17 Mar 2022 07:30:51 -0700 (PDT)
Received: from [10.39.193.107] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id di6-20020a170906730600b006df8831ec5asm1627334ejc.114.2022.03.17.07.30.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Mar 2022 07:30:51 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Dumitru Ceara <dceara@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH net] openvswitch: always update flow key after NAT
Date:   Thu, 17 Mar 2022 15:30:49 +0100
X-Mailer: MailMate (1.14r5875)
Message-ID: <2DD78E65-AE2E-4F6E-BF80-DCAFC2944E65@redhat.com>
In-Reply-To: <f7t1qz0he4c.fsf@redhat.com>
References: <20220317121729.2810292-1-aconole@redhat.com>
 <E3DEE4BD-F8BB-4B41-8310-9214B1431614@redhat.com>
 <f7t1qz0he4c.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17 Mar 2022, at 15:01, Aaron Conole wrote:

> Eelco Chaudron <echaudro@redhat.com> writes:
>
>> On 17 Mar 2022, at 13:17, Aaron Conole wrote:
>>
>>> During NAT, a tuple collision may occur.  When this happens, openvswi=
tch
>>> will make a second pass through NAT which will perform additional pac=
ket
>>> modification.  This will update the skb data, but not the flow key th=
at
>>> OVS uses.  This means that future flow lookups, and packet matches wi=
ll
>>> have incorrect data.  This has been supported since
>>> commit 5d50aa83e2c8 ("openvswitch: support asymmetric conntrack").
>>>
>>> That commit failed to properly update the sw_flow_key attributes, sin=
ce
>>> it only called the ovs_ct_nat_update_key once, rather than each time
>>> ovs_ct_nat_execute was called.  As these two operations are linked, t=
he
>>> ovs_ct_nat_execute() function should always make sure that the
>>> sw_flow_key is updated after a successful call through NAT infrastruc=
ture.
>>>
>>> Fixes: 5d50aa83e2c8 ("openvswitch: support asymmetric conntrack")
>>> Cc: Dumitru Ceara <dceara@redhat.com>
>>> Cc: Numan Siddique <nusiddiq@redhat.com>
>>> Signed-off-by: Aaron Conole <aconole@redhat.com>
>>> ---
>>>  net/openvswitch/conntrack.c | 20 ++++++++++++--------
>>>  1 file changed, 12 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.=
c
>>> index c07afff57dd3..461dbb3b7090 100644
>>> --- a/net/openvswitch/conntrack.c
>>> +++ b/net/openvswitch/conntrack.c
>>> @@ -104,6 +104,10 @@ static bool labels_nonzero(const struct ovs_key_=
ct_labels *labels);
>>>
>>>  static void __ovs_ct_free_action(struct ovs_conntrack_info *ct_info)=
;
>>>
>>> +static void ovs_nat_update_key(struct sw_flow_key *key,
>>> +			       const struct sk_buff *skb,
>>> +			       enum nf_nat_manip_type maniptype);
>>> +
>>
>> nit?: Rather than adding this would it be simpler to swap the order of=

>> ovs_nat_update_key and ovs_ct_nat_execute?
>
> I thought it looked messier that way.
>
>> Also, the function is defined by =E2=80=9C#if IS_ENABLED(CONFIG_NF_NAT=
)=E2=80=9D not
>> sure if this will generate warnings if the function is not present?
>
> Good catch, yes it will.  I will submit a v2 with this guard in place i=
f
> you think the foward decl is okay to keep.

I=E2=80=99m fine with either way, but I personally prefer the re-order as=
 the code looks cleaner (but the patch doesn't ;).

>>>  static u16 key_to_nfproto(const struct sw_flow_key *key)
>>>  {
>>>  	switch (ntohs(key->eth.type)) {
>>> @@ -741,7 +745,7 @@ static bool skb_nfct_cached(struct net *net,
>>>  static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *c=
t,
>>>  			      enum ip_conntrack_info ctinfo,
>>>  			      const struct nf_nat_range2 *range,
>>> -			      enum nf_nat_manip_type maniptype)
>>> +			      enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
>>>  {
>>>  	int hooknum, nh_off, err =3D NF_ACCEPT;
>>>
>>> @@ -813,6 +817,10 @@ static int ovs_ct_nat_execute(struct sk_buff *sk=
b, struct nf_conn *ct,
>>>  push:
>>>  	skb_push_rcsum(skb, nh_off);
>>>
>>> +	/* Update the flow key if NAT successful. */
>>> +	if (err =3D=3D NF_ACCEPT)
>>> +		ovs_nat_update_key(key, skb, maniptype);
>>> +
>>>  	return err;
>>>  }
>>>
>>> @@ -906,7 +914,7 @@ static int ovs_ct_nat(struct net *net, struct sw_=
flow_key *key,
>>>  	} else {
>>>  		return NF_ACCEPT; /* Connection is not NATed. */
>>>  	}
>>> -	err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype=
);
>>> +	err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype=
, key);
>>>
>>>  	if (err =3D=3D NF_ACCEPT && ct->status & IPS_DST_NAT) {
>>>  		if (ct->status & IPS_SRC_NAT) {
>>> @@ -916,17 +924,13 @@ static int ovs_ct_nat(struct net *net, struct s=
w_flow_key *key,
>>>  				maniptype =3D NF_NAT_MANIP_SRC;
>>>
>>>  			err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
>>> -						 maniptype);
>>> +						 maniptype, key);
>>>  		} else if (CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_ORIGINAL) {
>>>  			err =3D ovs_ct_nat_execute(skb, ct, ctinfo, NULL,
>>> -						 NF_NAT_MANIP_SRC);
>>> +						 NF_NAT_MANIP_SRC, key);
>>>  		}
>>>  	}
>>>
>>> -	/* Mark NAT done if successful and update the flow key. */
>>> -	if (err =3D=3D NF_ACCEPT)
>>> -		ovs_nat_update_key(key, skb, maniptype);
>>> -
>>>  	return err;
>>>  }
>>>  #else /* !CONFIG_NF_NAT */
>>
>> The rest of the patch looks fine to me...

