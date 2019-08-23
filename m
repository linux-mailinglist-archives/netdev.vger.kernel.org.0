Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7969B9AD6D
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 12:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731756AbfHWKj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 06:39:56 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:50758
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726142AbfHWKj4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 06:39:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ih9pegmRyWo6U13SxKDxgobdENw8s2WffFBkpwy5u2Id1bCJ/FhLVCad2zeUVOr9WiE1Q1G8eLJymanpABOT1IgT2nDvR+dNrmJf/xd+hyF1PVVfCBDoqRzJGpYIqtiIeXr7Kp4AaPfBAqF7FMv/alyVX+5U0foPrW/usiR6+wBlOYrwre1fgioGN4TA9rQwQpZ+qOcudaoHG+nFFWXbC+OP5VwJDVc2oL4CR7lfKw3XfPigKkQaFE/gmBzt8OKHAW31F9z843MmP9OAOR1OaTx+KpTq3wcsPv2VEloVfyOx/nrd7fHq018YJ3Kfwb0uAwFdlR5sQuYPJm13RPKpYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rztyQGcOdy4abHjTOkyQKcgmvL4NbOLABL4k5nahmP4=;
 b=bnsbwjSeFLaMGZRlOomV+e4OA2E7Q5zqzMhhhFP4m+XoyvbqfGnXYE7hbjyzZANic6VF8qI2qzFHd1raSOIS6y/6KpOdmqo9DO+XpTBMbaQtuisUuKwdQi+v644CcOo2POGl/ioWZTcoCD2oi7Vcp4hUid2V2roiU9RJEONGkpAlTpoBvQwfVEsZFIu3HVdedwNEafb4cI16uWqinl7mDOp+pYUK9EsoBFyigFpJa2dwOjBPojkJhH2tIp1CjdJAgwz3YXxtfJdTcpRONGbhOFwoM38N/pBkAXwpnbfQWZEjInJ0zaLWQDi0R3OBRpe3MpNvNS68rHDQ70CVQ5pydw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rztyQGcOdy4abHjTOkyQKcgmvL4NbOLABL4k5nahmP4=;
 b=KGPat1Dxy/cHA8fbAuo/ruGUX/DYfsjrljGCkx9LQJL2ie5L7qDu1TLrFgoJag3gMN/8LWbKV4DlwwXu2B71Jw+SJlRpnyM8rUZt7Z7xUSgiZmwTOyTjvR1HdsCwlf35Ea2vzbvv6s5Cvv1Au7+YCuorWYYIi8WFypm1jchJK7Q=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5982.eurprd05.prod.outlook.com (20.178.127.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 23 Aug 2019 10:39:50 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.020; Fri, 23 Aug 2019
 10:39:50 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 03/10] net: sched: refactor block offloads
 counter usage
Thread-Topic: [PATCH net-next 03/10] net: sched: refactor block offloads
 counter usage
Thread-Index: AQHVWOdX+z+ICsVOPEOamT2xT1ruGacHxygAgADFMgA=
Date:   Fri, 23 Aug 2019 10:39:50 +0000
Message-ID: <vbfftls17yl.fsf@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
 <20190822124353.16902-4-vladbu@mellanox.com>
 <20190822155358.0171852c@cakuba.netronome.com>
In-Reply-To: <20190822155358.0171852c@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0001.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::13) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8daf9f0-1335-4313-9e21-08d727b639ab
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5982;
x-ms-traffictypediagnostic: VI1PR05MB5982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5982B6077F547B40BDA55643ADA40@VI1PR05MB5982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(189003)(199004)(81156014)(8676002)(81166006)(25786009)(4326008)(107886003)(6246003)(76176011)(53936002)(6506007)(386003)(102836004)(26005)(66066001)(186003)(86362001)(36756003)(14444005)(52116002)(256004)(99286004)(71190400001)(71200400001)(476003)(2616005)(486006)(446003)(316002)(54906003)(6916009)(478600001)(6436002)(3846002)(6116002)(30864003)(7736002)(305945005)(5660300002)(229853002)(66946007)(6486002)(66556008)(8936002)(66476007)(14454004)(11346002)(66446008)(64756008)(2906002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5982;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RWPREfHrEo2IdmqQtCq00nOF3Yt8WnTFjDwbdEO+J0etg3ZxCjW9S0miMgD5kmuhScIWvtxT8w2X5/m0EG5mSk+wfo8a+A16MOTNQb2+7finK3vnU4vK4OB+tTJ0VGVPiyMvDvFOkLp0/D2smPumRMHrz5n0L7MmZ+FIagbX9HUqtXThfnqg87C+KPBYNbRh4fhVBRfLHABZGdLPxCoUyF3eAMBB7D2UeAMyG8p6OckMqccawNLa/jYbi5onl/MJDZO/xsG7SenmMCrSDRD4r0wycmo4raeQLkrjAdWr0QzGULr74gUuO+OeLyGivXB1EHMtNb4M9PNHdKV5JR3ZSx5FMoXdGoogqjRm/4AERNzCE85KIzve+soDYm3O075XD2HqVKDnrHQC+8v2AfdGBlQqeAPMRFRQnd7HcwK2Ikk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8daf9f0-1335-4313-9e21-08d727b639ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 10:39:50.3013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sSiZJMYVKZE0ECFBt2jmI0znHYsOpcoJiXoRH71XchGsW/1BVXsoPyo7pByU55lpbUMKhtpmLz+pVKh4zVBkaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 23 Aug 2019 at 01:53, Jakub Kicinski <jakub.kicinski@netronome.com> =
wrote:
> On Thu, 22 Aug 2019 15:43:46 +0300, Vlad Buslov wrote:
>> Without rtnl lock protection filters can no longer safely manage block
>> offloads counter themselves. Refactor cls API to protect block offloadcn=
t
>> with tcf_block->cb_lock that is already used to protect driver callback
>> list and nooffloaddevcnt counter. The counter can be modified by concurr=
ent
>> tasks by new functions that execute block callbacks (which is safe with
>> previous patch that changed its type to atomic_t), however, block
>> bind/unbind code that checks the counter value takes cb_lock in write mo=
de
>> to exclude any concurrent modifications. This approach prevents race
>> conditions between bind/unbind and callback execution code but allows fo=
r
>> concurrency for tc rule update path.
>>
>> Move block offload counter, filter in hardware counter and filter flags
>> management from classifiers into cls hardware offloads API. Make functio=
ns
>> tcf_block_offload_inc() and tcf_block_offload_dec() to be cls API privat=
e.
>> Implement following new cls API to be used instead:
>>
>>   tc_setup_cb_add() - non-destructive filter add. If filter that wasn't
>>   already in hardware is successfully offloaded, increment block offload=
s
>>   counter, set filter in hardware counter and flag. On failure, previous=
ly
>>   offloaded filter is considered to be intact and offloads counter is no=
t
>>   decremented.
>>
>>   tc_setup_cb_replace() - destructive filter replace. Release existing
>>   filter block offload counter and reset its in hardware counter and fla=
g.
>>   Set new filter in hardware counter and flag. On failure, previously
>>   offloaded filter is considered to be destroyed and offload counter is
>>   decremented.
>>
>>   tc_setup_cb_destroy() - filter destroy. Unconditionally decrement bloc=
k
>>   offloads counter.
>>
>> Refactor all offload-capable classifiers to atomically offload filters t=
o
>> hardware, change block offload counter, and set filter in hardware count=
er
>> and flag by means of the new cls API functions.
>>
>> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>> Acked-by: Jiri Pirko <jiri@mellanox.com>
>
> Looks good, minor nits
>
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> index 8502bd006b37..4215c849f4a3 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
>> @@ -3000,13 +3000,97 @@ int tcf_exts_dump_stats(struct sk_buff *skb, str=
uct tcf_exts *exts)
>>  }
>>  EXPORT_SYMBOL(tcf_exts_dump_stats);
>>
>> -int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
>> -		     void *type_data, bool err_stop)
>> +static void tcf_block_offload_inc(struct tcf_block *block, u32 *flags)
>> +{
>> +	if (*flags & TCA_CLS_FLAGS_IN_HW)
>> +		return;
>> +	*flags |=3D TCA_CLS_FLAGS_IN_HW;
>> +	atomic_inc(&block->offloadcnt);
>> +}
>> +
>> +static void tcf_block_offload_dec(struct tcf_block *block, u32 *flags)
>> +{
>> +	if (!(*flags & TCA_CLS_FLAGS_IN_HW))
>> +		return;
>> +	*flags &=3D ~TCA_CLS_FLAGS_IN_HW;
>> +	atomic_dec(&block->offloadcnt);
>> +}
>> +
>> +void tc_cls_offload_cnt_update(struct tcf_block *block, struct tcf_prot=
o *tp,
>> +			       u32 *cnt, u32 *flags, u32 diff, bool add)
>> +{
>> +	lockdep_assert_held(&block->cb_lock);
>> +
>> +	spin_lock(&tp->lock);
>> +	if (add) {
>> +		if (!*cnt)
>> +			tcf_block_offload_inc(block, flags);
>> +		(*cnt) +=3D diff;
>
> brackets unnecessary
>
>> +	} else {
>> +		(*cnt) -=3D diff;
>> +		if (!*cnt)
>> +			tcf_block_offload_dec(block, flags);
>> +	}
>> +	spin_unlock(&tp->lock);
>> +}
>> +EXPORT_SYMBOL(tc_cls_offload_cnt_update);
>> +
>> +static void
>> +tc_cls_offload_cnt_reset(struct tcf_block *block, struct tcf_proto *tp,
>> +			 u32 *cnt, u32 *flags)
>> +{
>> +	lockdep_assert_held(&block->cb_lock);
>> +
>> +	spin_lock(&tp->lock);
>> +	tcf_block_offload_dec(block, flags);
>> +	(*cnt) =3D 0;
>
> ditto
>
>> +	spin_unlock(&tp->lock);
>> +}
>> +
>> +static int
>> +__tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
>> +		   void *type_data, bool err_stop)
>>  {
>>  	struct flow_block_cb *block_cb;
>>  	int ok_count =3D 0;
>>  	int err;
>>
>> +	list_for_each_entry(block_cb, &block->flow_block.cb_list, list) {
>> +		err =3D block_cb->cb(type, type_data, block_cb->cb_priv);
>> +		if (err) {
>> +			if (err_stop)
>> +				return err;
>> +		} else {
>> +			ok_count++;
>> +		}
>> +	}
>> +	return ok_count;
>> +}
>> +
>> +int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
>> +		     void *type_data, bool err_stop, bool rtnl_held)
>> +{
>> +	int ok_count;
>> +
>> +	down_read(&block->cb_lock);
>> +	ok_count =3D __tc_setup_cb_call(block, type, type_data, err_stop);
>> +	up_read(&block->cb_lock);
>> +	return ok_count;
>> +}
>> +EXPORT_SYMBOL(tc_setup_cb_call);
>> +
>> +/* Non-destructive filter add. If filter that wasn't already in hardwar=
e is
>> + * successfully offloaded, increment block offloads counter. On failure=
,
>> + * previously offloaded filter is considered to be intact and offloads =
counter
>> + * is not decremented.
>> + */
>> +
>
> Spurious new line here?
>
>> +int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
>> +		    enum tc_setup_type type, void *type_data, bool err_stop,
>> +		    u32 *flags, unsigned int *in_hw_count, bool rtnl_held)
>> +{
>> +	int ok_count;
>> +
>>  	down_read(&block->cb_lock);
>>  	/* Make sure all netdevs sharing this block are offload-capable. */
>>  	if (block->nooffloaddevcnt && err_stop) {
>> @@ -3014,22 +3098,67 @@ int tc_setup_cb_call(struct tcf_block *block, en=
um tc_setup_type type,
>>  		goto errout;
>>  	}
>>
>> -	list_for_each_entry(block_cb, &block->flow_block.cb_list, list) {
>> -		err =3D block_cb->cb(type, type_data, block_cb->cb_priv);
>> -		if (err) {
>> -			if (err_stop) {
>> -				ok_count =3D err;
>> -				goto errout;
>> -			}
>> -		} else {
>> -			ok_count++;
>> -		}
>> +	ok_count =3D __tc_setup_cb_call(block, type, type_data, err_stop);
>> +	if (ok_count > 0)
>> +		tc_cls_offload_cnt_update(block, tp, in_hw_count, flags,
>> +					  ok_count, true);
>> +errout:
>
> and the labels again
>
>> +	up_read(&block->cb_lock);
>> +	return ok_count;
>> +}
>> +EXPORT_SYMBOL(tc_setup_cb_add);
>> +
>> +/* Destructive filter replace. If filter that wasn't already in hardwar=
e is
>> + * successfully offloaded, increment block offload counter. On failure,
>> + * previously offloaded filter is considered to be destroyed and offloa=
d counter
>> + * is decremented.
>> + */
>> +
>
> spurious new line?
>
>> +int tc_setup_cb_replace(struct tcf_block *block, struct tcf_proto *tp,
>> +			enum tc_setup_type type, void *type_data, bool err_stop,
>> +			u32 *old_flags, unsigned int *old_in_hw_count,
>> +			u32 *new_flags, unsigned int *new_in_hw_count,
>> +			bool rtnl_held)
>> +{
>> +	int ok_count;
>> +
>> +	down_read(&block->cb_lock);
>> +	/* Make sure all netdevs sharing this block are offload-capable. */
>> +	if (block->nooffloaddevcnt && err_stop) {
>> +		ok_count =3D -EOPNOTSUPP;
>> +		goto errout;
>>  	}
>> +
>> +	tc_cls_offload_cnt_reset(block, tp, old_in_hw_count, old_flags);
>> +
>> +	ok_count =3D __tc_setup_cb_call(block, type, type_data, err_stop);
>> +	if (ok_count > 0)
>> +		tc_cls_offload_cnt_update(block, tp, new_in_hw_count, new_flags,
>> +					  ok_count, true);
>>  errout:
>>  	up_read(&block->cb_lock);
>>  	return ok_count;
>>  }
>> -EXPORT_SYMBOL(tc_setup_cb_call);
>> +EXPORT_SYMBOL(tc_setup_cb_replace);
>> +
>> +/* Destroy filter and decrement block offload counter, if filter was pr=
eviously
>> + * offloaded.
>> + */
>> +
>
> hm.. is this gap between comment and function it pertains to
> intentional?

Majority of function comments in cls_api.c have newline after them (not
all of them though). I don't have any strong opinions regarding this.
You suggest it is better not to have blank lines after function
comments?

>
>> +int tc_setup_cb_destroy(struct tcf_block *block, struct tcf_proto *tp,
>> +			enum tc_setup_type type, void *type_data, bool err_stop,
>> +			u32 *flags, unsigned int *in_hw_count, bool rtnl_held)
>> +{
>> +	int ok_count;
>> +
>> +	down_read(&block->cb_lock);
>> +	ok_count =3D __tc_setup_cb_call(block, type, type_data, err_stop);
>> +
>> +	tc_cls_offload_cnt_reset(block, tp, in_hw_count, flags);
>> +	up_read(&block->cb_lock);
>> +	return ok_count;
>> +}
>> +EXPORT_SYMBOL(tc_setup_cb_destroy);
>>
>>  int tc_setup_flow_action(struct flow_action *flow_action,
>>  			 const struct tcf_exts *exts)
>> diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
>> index 3f7a9c02b70c..7f304db7e697 100644
>> --- a/net/sched/cls_bpf.c
>> +++ b/net/sched/cls_bpf.c
>> @@ -162,17 +162,21 @@ static int cls_bpf_offload_cmd(struct tcf_proto *t=
p, struct cls_bpf_prog *prog,
>>  	cls_bpf.name =3D obj->bpf_name;
>>  	cls_bpf.exts_integrated =3D obj->exts_integrated;
>>
>> -	if (oldprog)
>> -		tcf_block_offload_dec(block, &oldprog->gen_flags);
>> +	if (cls_bpf.oldprog)
>
> why the change from oldprog to cls_bpf.oldprog?

No reason. Looks like a mistake I made when rewriting the conditional
for new tc_setup_cb_*() API.

>
>> +		err =3D tc_setup_cb_replace(block, tp, TC_SETUP_CLSBPF, &cls_bpf,
>> +					  skip_sw, &oldprog->gen_flags,
>> +					  &oldprog->in_hw_count,
>> +					  &prog->gen_flags, &prog->in_hw_count,
>> +					  true);
>> +	else
>> +		err =3D tc_setup_cb_add(block, tp, TC_SETUP_CLSBPF, &cls_bpf,
>> +				      skip_sw, &prog->gen_flags,
>> +				      &prog->in_hw_count, true);
>>
>> -	err =3D tc_setup_cb_call(block, TC_SETUP_CLSBPF, &cls_bpf, skip_sw);
>>  	if (prog) {
>>  		if (err < 0) {
>>  			cls_bpf_offload_cmd(tp, oldprog, prog, extack);
>>  			return err;
>> -		} else if (err > 0) {
>> -			prog->in_hw_count =3D err;
>> -			tcf_block_offload_inc(block, &prog->gen_flags);
>>  		}
>>  	}
>>
>> @@ -230,7 +234,7 @@ static void cls_bpf_offload_update_stats(struct tcf_=
proto *tp,
>>  	cls_bpf.name =3D prog->bpf_name;
>>  	cls_bpf.exts_integrated =3D prog->exts_integrated;
>>
>> -	tc_setup_cb_call(block, TC_SETUP_CLSBPF, &cls_bpf, false);
>> +	tc_setup_cb_call(block, TC_SETUP_CLSBPF, &cls_bpf, false, true);
>>  }
>>
>>  static int cls_bpf_init(struct tcf_proto *tp)
>> @@ -680,8 +684,8 @@ static int cls_bpf_reoffload(struct tcf_proto *tp, b=
ool add, flow_setup_cb_t *cb
>>  			continue;
>>  		}
>>
>> -		tc_cls_offload_cnt_update(block, &prog->in_hw_count,
>> -					  &prog->gen_flags, add);
>> +		tc_cls_offload_cnt_update(block, tp, &prog->in_hw_count,
>> +					  &prog->gen_flags, 1, add);
>
> Since we're adding those higher level add/replace/destroy helpers,
> would it also be possible to have a helper which takes care of
> reoffload? tc_cls_offload_cnt_update() is kind of low level now, it'd
> be cool to also hide it in the core.

Agree. I'll try to come up with something more elegant.

>
>>  	}
>>
>>  	return 0;
>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>> index 054123742e32..0001a933d48b 100644
>> --- a/net/sched/cls_flower.c
>> +++ b/net/sched/cls_flower.c
>> @@ -419,10 +419,10 @@ static void fl_hw_destroy_filter(struct tcf_proto =
*tp, struct cls_fl_filter *f,
>>  	cls_flower.command =3D FLOW_CLS_DESTROY;
>>  	cls_flower.cookie =3D (unsigned long) f;
>>
>> -	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
>> +	tc_setup_cb_destroy(block, tp, TC_SETUP_CLSFLOWER, &cls_flower, false,
>> +			    &f->flags, &f->in_hw_count, true);
>>  	spin_lock(&tp->lock);
>>  	list_del_init(&f->hw_list);
>> -	tcf_block_offload_dec(block, &f->flags);
>>  	spin_unlock(&tp->lock);
>>
>>  	if (!rtnl_held)
>> @@ -466,18 +466,15 @@ static int fl_hw_replace_filter(struct tcf_proto *=
tp,
>>  		goto errout;
>>  	}
>>
>> -	err =3D tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, skip_=
sw);
>> +	err =3D tc_setup_cb_add(block, tp, TC_SETUP_CLSFLOWER, &cls_flower,
>> +			      skip_sw, &f->flags, &f->in_hw_count, true);
>>  	kfree(cls_flower.rule);
>>
>>  	if (err < 0) {
>>  		fl_hw_destroy_filter(tp, f, true, NULL);
>>  		goto errout;
>>  	} else if (err > 0) {
>> -		f->in_hw_count =3D err;
>>  		err =3D 0;
>
> Why does the tc_setup_cb* API still return the positive values, the
> callers should no longer care, right?

Yep. I'll refactor this for V2 and simplify related conditionals in
classifiers.

>
>> -		spin_lock(&tp->lock);
>> -		tcf_block_offload_inc(block, &f->flags);
>> -		spin_unlock(&tp->lock);
>>  	}
>>
>>  	if (skip_sw && !(f->flags & TCA_CLS_FLAGS_IN_HW)) {
