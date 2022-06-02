Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD9653B6C3
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 12:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiFBKQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 06:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiFBKQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 06:16:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2262AD5CA;
        Thu,  2 Jun 2022 03:16:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2C8BB81D81;
        Thu,  2 Jun 2022 10:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41851C385A5;
        Thu,  2 Jun 2022 10:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654164981;
        bh=CL8CyiPJdPlBC+h4F1u1wxFNsh2k6bt2bGpU8CbPtYc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=IKn9oGFrgl1Uz9rgQqJTOF9ephY80iOFywJgvMLFs/Ea0URR/91M9H0dFIAh3u8sK
         Jr5nEXBevVoHoR2ZCQMffNW5EJJiMQdMED2FqAFjpfVgvFlgfMrQJS/W2UAkpfEYmZ
         aCihRx503ZHgPH4cLSeADHBcOtoDfy2qGCbY2kIrTiTW39KKID5lljgIyMGw6l76cV
         pO6e6n4jfQjc0tRR2NQAj/F5cc72dfqy5bGwgcOTkz+es2GtcZRCPtOi32FF3BXWI1
         DxZNwOUM3aYD32Zc/V/xZ5ToNWlefyJD1tPyUe//r5N6bglrgVB3GT4litxqa79M5l
         T2jpdqyZV4fhQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9901140527B; Thu,  2 Jun 2022 12:16:16 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     shaozhengchao <shaozhengchao@huawei.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
Cc:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: Re: =?utf-8?B?562U5aSNOg==?= [PATCH v5,bpf-next] samples/bpf: check
 detach prog exist or
 not in xdp_fwd
In-Reply-To: <f7e88b843e964632919c8efe16368786@huawei.com>
References: <20220602011915.264431-1-shaozhengchao@huawei.com>
 <87v8tjsavb.fsf@toke.dk> <f7e88b843e964632919c8efe16368786@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 02 Jun 2022 12:16:16 +0200
Message-ID: <87leufs74f.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

shaozhengchao <shaozhengchao@huawei.com> writes:

> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Toke H=C3=B8iland-J=C3=B8rgensen [mailto:tok=
e@kernel.org]=20
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2022=E5=B9=B46=E6=9C=882=E6=97=A5 1=
6:55
> =E6=94=B6=E4=BB=B6=E4=BA=BA: shaozhengchao <shaozhengchao@huawei.com>; bp=
f@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; as=
t@kernel.org; daniel@iogearbox.net; davem@davemloft.net; kuba@kernel.org; h=
awk@kernel.org; john.fastabend@gmail.com; andrii@kernel.org; kafai@fb.com; =
songliubraving@fb.com; yhs@fb.com; kpsingh@kernel.org
> =E6=8A=84=E9=80=81: weiyongjun (A) <weiyongjun1@huawei.com>; shaozhengcha=
o <shaozhengchao@huawei.com>; yuehaibing <yuehaibing@huawei.com>
> =E4=B8=BB=E9=A2=98: Re: [PATCH v5,bpf-next] samples/bpf: check detach pro=
g exist or not in xdp_fwd
>
> Zhengchao Shao <shaozhengchao@huawei.com> writes:
>
>> Before detach the prog, we should check detach prog exist or not.
>>
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>
> You missed one 'return errno', see below:
>
>> ---
>>  samples/bpf/xdp_fwd_user.c | 55=20
>> +++++++++++++++++++++++++++++++++-----
>>  1 file changed, 49 insertions(+), 6 deletions(-)
>>
>> diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c=20
>> index 1828487bae9a..d321e6aa9364 100644
>> --- a/samples/bpf/xdp_fwd_user.c
>> +++ b/samples/bpf/xdp_fwd_user.c
>> @@ -47,17 +47,60 @@ static int do_attach(int idx, int prog_fd, int map_f=
d, const char *name)
>>  	return err;
>>  }
>>=20=20
>> -static int do_detach(int idx, const char *name)
>> +static int do_detach(int ifindex, const char *ifname, const char=20
>> +*app_name)
>>  {
>> -	int err;
>> +	LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
>> +	struct bpf_prog_info prog_info =3D {};
>> +	char prog_name[BPF_OBJ_NAME_LEN];
>> +	__u32 info_len, curr_prog_id;
>> +	int prog_fd;
>> +	int err =3D 1;
>> +
>> +	if (bpf_xdp_query_id(ifindex, xdp_flags, &curr_prog_id)) {
>> +		printf("ERROR: bpf_xdp_query_id failed (%s)\n",
>> +		       strerror(errno));
>> +		return err;
>> +	}
>>=20=20
>> -	err =3D bpf_xdp_detach(idx, xdp_flags, NULL);
>> -	if (err < 0)
>> -		printf("ERROR: failed to detach program from %s\n", name);
>> +	if (!curr_prog_id) {
>> +		printf("ERROR: flags(0x%x) xdp prog is not attached to %s\n",
>> +		       xdp_flags, ifname);
>> +		return err;
>> +	}
>>=20=20
>> +	info_len =3D sizeof(prog_info);
>> +	prog_fd =3D bpf_prog_get_fd_by_id(curr_prog_id);
>> +	if (prog_fd < 0) {
>> +		printf("ERROR: bpf_prog_get_fd_by_id failed (%s)\n",
>> +		       strerror(errno));
>> +		return errno;
>
> This should just be ' return prog_fd ' to propagate the error...
>
> -Toke
>
>
> Hi Toke:
> 	Use 'return prog_fd' instead of 'return errno' first. And Which
> position missed one 'return errno'?

Ah, no, that's the one I was talking about; I meant "missed one" as in
"missed removing one of them", not "a return errno was missing but
should be there"; so just changing that one to 'return prog_fd' should
and I think we should be good :)

-Toke
