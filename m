Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D835897D6
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 08:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiHDGk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 02:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiHDGk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 02:40:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCA8BC8E;
        Wed,  3 Aug 2022 23:40:57 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1659595254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bSk08bkNlpYDlbdzO3aE5gLjc33dPKODmc2QenLeSYU=;
        b=LYFkNSEAfzl0GHTHbeeaxVZeF/Zfsrv/vsAnoCXvkD2CHkxMnIOMOj44Nk8oH7DAUHeFHt
        xS6R6NHDLpBL0F7l8Vd/FoUdQ9mIcAynbRoP/uZBI2R4/9mjdQdUpIfspLOr0pHFe7+dwe
        yZp9o3UlzrEE62vszlftlo6wxlAJYhZJdp8j7T01kkVUT6eitW/3yL4DWMmQ5POJ0BEEDg
        u75cyxKwSPox9VvYpw7YE5Jqa8u16tnhz52v8PcCXKcrtHrkht3i8OOPpAng5OyobKQLFR
        2cEKjyH+d14NhT2697EdspylFfxbu37BXrpYO6BhQLspDEhequZ1uK7c2+HRUw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1659595254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bSk08bkNlpYDlbdzO3aE5gLjc33dPKODmc2QenLeSYU=;
        b=Rq3tzWEeTS4Kr7ST9RCXYESW1NqRTBYOs0OUduR3g02AQ8NlhYH0SG/bIkF584BH81hR9x
        61d9te2ij2rMoeDQ==
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
In-Reply-To: <CAEf4BzZtraeLSP4wcNk7t4sqDK6t2HVoo57nkUhVVLNCWe=JfA@mail.gmail.com>
References: <20220606103734.92423-1-kurt@linutronix.de>
 <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
 <875ylc6djv.ffs@tglx> <c166aa47-e404-e6ee-0ec5-0ead1923f412@redhat.com>
 <CAADnVQKqo1XfrPO8OYA1VpArKHZotuDjGNtxM0AftUj_R+vU7g@mail.gmail.com>
 <87pmhj15vf.fsf@kurt>
 <CAADnVQ+aDn9ku8p0M2yaPQb_Qi3CxkcyhHbcKTq8y2hrDP5A8Q@mail.gmail.com>
 <87edxxg7qu.fsf@kurt>
 <CAEf4BzZtraeLSP4wcNk7t4sqDK6t2HVoo57nkUhVVLNCWe=JfA@mail.gmail.com>
Date:   Thu, 04 Aug 2022 08:40:51 +0200
Message-ID: <87k07o1pfw.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Wed Aug 03 2022, Andrii Nakryiko wrote:
>> +void test_tai(void)
>> +{
>> +       struct __sk_buff skb = {
>> +               .tstamp = 0,
>> +               .hwtstamp = 0,
>> +       };
>> +       LIBBPF_OPTS(bpf_test_run_opts, topts,
>> +               .data_in = &pkt_v4,
>> +               .data_size_in = sizeof(pkt_v4),
>> +               .ctx_in = &skb,
>> +               .ctx_size_in = sizeof(skb),
>> +               .ctx_out = &skb,
>> +               .ctx_size_out = sizeof(skb),
>> +       );
>> +       struct timespec now_tai;
>> +       struct bpf_object *obj;
>> +       int ret, prog_fd;
>> +
>> +       ret = bpf_prog_test_load("./test_tai.o",
>> +                                BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
>
> it would be best to rely on BPF skeleton, please see other tests
> including *.skel.h, thanks
>

Ah, nice. Adjusted the test case accordingly. Will post v2 after the
merge window. Thanks!

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmLrafMTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgsOYD/wNaF06Og6TEXbnkXlu1CNHxnV0v+yx
Nj0uHcBIJQJSHyd98URvTOARdaL4xRAvZY7Km88lFIQUy6JFPJI9lkvIbLbFbZcH
vgWiZWdW7PD4OmVbYlYI5gFz7RCk+uanRRp7xIcUyVPRiEQ8cPPXOQzgr5W/9+9X
zLqCTWtfzXErh9eczVNtrjiRY+kDKMJqLNUyEyl6BVx3aGgcSpStQeyBXx282njh
kEfPn1bz+kjaQFudN6GBjkYjNG4MPgTOUzc1WbBpdEjsL9Oa0QemMLCMihbc2PSM
SIM5/YMVd12o0eS/8Ca9lanrZ8IyNOaH9ZAHT1mJeBT5QU0rwK1afrBNzr/L0ZKE
1D1z6+MSsNWrJGOKdOH8MG0Q8va7+xBs4KOQuAdBJIWGimsRYszOmPurYI04f6i+
+1/RzQZ92ima0rz9Q4O8J4gnxhv11Ttp+NiQp+rgdOsMgKWg0aT2+WcSLiZaC3nr
y87mPxW6F3CmBJdeBmAjLseqFAhLDfXAgJANPRvqpgbFUJNoMe0nXDaPJrd31PlE
46iF0in1dMZPeLe6vaHIgTxht7uB2Dsbd5B8nTq2lQPb0ThQAKQX9lLeoOPUVjaQ
pUdkCoxFFBZHW79j2AHKYEOGnIE+IeuIfycEdkWoE9LH1gmUf5giZvmgVo1RCbeu
QymM8Gpg0sGUtw==
=f9AS
-----END PGP SIGNATURE-----
--=-=-=--
