Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F72D4AC811
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236269AbiBGR7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345915AbiBGRxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:53:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B545C0401D9;
        Mon,  7 Feb 2022 09:53:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E79F061265;
        Mon,  7 Feb 2022 17:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A59C004E1;
        Mon,  7 Feb 2022 17:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644256420;
        bh=J/5npvl2AWJR5CZyz4n1OKbcZJe3W/JUn6lsfy2Lq2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WUaGbeOkGK8q0zSj9WIbfCMzICxJHWhH7uPA8uALbb5tft9vuA3gJGKmYh15bMAwT
         5i+0Rime8i/kN5BBE0SlwLTl62IOycTNsnZRbQ9SUblQ3Pl7gSxCSiiAwNRVXLGbDm
         w9pRkRK3o8lnvD8B8lMN5HI4a+xMyUHAudJ4BE6W7F3n0KrPx927/DqDWkcFBk22+v
         GzbwX6liuKM48swPFGl+mp0QNnUYQGQqQGlgEuXmDwLbs+63uMWO7oWjJcxKN0r4Ce
         YOHEwrpeGvhvgyfuEfzhidjR6LHJnl9/y0gz4i3ovrDD5wfV/nROczEK1JlZcQWQzb
         OAnACashZrlWQ==
Date:   Mon, 7 Feb 2022 18:53:35 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        brouer@redhat.com, toke@redhat.com, andrii@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next] selftest/bpf: check invalid length in
 test_xdp_update_frags
Message-ID: <YgFcn487ZHk8e2VP@lore-desk>
References: <aff68ca785cae86cd6263355010ceaff24daee1f.1643982947.git.lorenzo@kernel.org>
 <c3858f6b-43d5-18ef-2fc8-b58c13c12b05@fb.com>
 <Yf1nxMWEWy4DSwgN@lore-desk>
 <15f829a2-8556-0545-7408-3fca66eb38b7@fb.com>
 <Yf1w2HRokiYBg8w9@lore-desk>
 <Yf15n2GJG70JrxX6@lore-desk>
 <c03f0c81-8e56-6c92-d31a-03a5394b9388@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9OLtDuQbpDP0jtNd"
Content-Disposition: inline
In-Reply-To: <c03f0c81-8e56-6c92-d31a-03a5394b9388@fb.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9OLtDuQbpDP0jtNd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 2/4/22 11:08 AM, Lorenzo Bianconi wrote:
> > > >=20
> > >=20
> > > [...]
> > >=20
> > > > > >=20
> > > > > > In kernel, the nr_frags checking is against MAX_SKB_FRAGS,
> > > > > > but if /proc/sys/net/core/max_skb_flags is 2 or more less
> > > > > > than MAX_SKB_FRAGS, the test won't fail, right?
> > > > >=20
> > > > > yes, you are right. Should we use the same definition used in
> > > > > include/linux/skbuff.h instead? Something like:
> > > > >=20
> > > > > if (65536 / page_size + 1 < 16)
> > > > > 	max_skb_flags =3D 16;
> > > > > else
> > > > > 	max_skb_flags =3D 65536/page_size + 1;
> > > >=20
> > > > The maximum packet size limit 64KB won't change anytime soon.
> > > > So the above should work. Some comments to explain why using
> > > > the above formula will be good.
> > >=20
> > > ack, I will do in v2.
> >=20
> > I can see there is a on-going discussion here [0] about increasing
> > MAX_SKB_FRAGS. I guess we can put on-hold this patch and see how
> > MAX_SKB_FRAGS will be changed.
>=20
> Thanks for the link. The new patch is going to increase
> MAX_SKB_FRAGS and it is possible that will be changed again
> (maybe under some config options).
>=20
> The default value for
> /proc/sys/net/core/max_skb_flags is MAX_SKB_FRAGS and I suspect
> anybody is bothering to change it. So your patch is okay to me.
> Maybe change a little bit -ENOMEM error message. current,
>   ASSERT_EQ(err, -ENOMEM, "unsupported buffer size");
> to
>   ASSERT_EQ(err, -ENOMEM, "unsupported buffer size, possible non-default
> /proc/sys/net/core/max_skb_flags?");

ack, I am fine with it.
@Alexei, Andrii: any hints about it?

Regards,
Lorenzo

>=20
> >=20
> > Regards,
> > Lorenzo
> >=20
> > [0] https://lore.kernel.org/all/202202031315.B425Ipe8-lkp@intel.com/t/#=
ma1b2c7e71fe9bc69e24642a62dadf32fda7d5f03
> >=20
> > >=20
> > > Regards,
> > > Lorenzo
> > >=20
> > > >=20
> > > > >=20
> > > > > Regards,
> > > > > Lorenzo
> > > > >=20
> > > > > >=20
> > > > > > > +
> > > > > > > +	num =3D fscanf(f, "%d", &max_skb_frags);
> > > > > > > +	fclose(f);
> > > > > > > +
> > > > > > > +	if (!ASSERT_EQ(num, 1, "max_skb_frags read failed"))
> > > > > > > +		goto out;
> > > > > > > +
> > > > > > > +	/* xdp_buff linear area size is always set to 4096 in the
> > > > > > > +	 * bpf_prog_test_run_xdp routine.
> > > > > > > +	 */
> > > > > > > +	buf_size =3D 4096 + (max_skb_frags + 1) * sysconf(_SC_PAGE_=
SIZE);
> > > > > > > +	buf =3D malloc(buf_size);
> > > > > > > +	if (!ASSERT_OK_PTR(buf, "alloc buf"))
> > > > > > > +		goto out;
> > > > > > > +
> > > > > > > +	memset(buf, 0, buf_size);
> > > > > > > +	offset =3D (__u32 *)buf;
> > > > > > > +	*offset =3D 16;
> > > > > > > +	buf[*offset] =3D 0xaa;
> > > > > > > +	buf[*offset + 15] =3D 0xaa;
> > > > > > > +
> > > > > > > +	topts.data_in =3D buf;
> > > > > > > +	topts.data_out =3D buf;
> > > > > > > +	topts.data_size_in =3D buf_size;
> > > > > > > +	topts.data_size_out =3D buf_size;
> > > > > > > +
> > > > > > > +	err =3D bpf_prog_test_run_opts(prog_fd, &topts);
> > > > > > > +	ASSERT_EQ(err, -ENOMEM, "unsupported buffer size");
> > > > > > > +	free(buf);
> > > > > > >     out:
> > > > > > >     	bpf_object__close(obj);
> > > > > > >     }
> > > > > >=20
> > > >=20
> >=20
> >=20

--9OLtDuQbpDP0jtNd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYgFcnwAKCRA6cBh0uS2t
rBo4AQD515rOMGBMkdaQ+noY6PJY1THC3o1ciSn987z53aJr4gD/Z9k2fwFJPnoY
i3+j93idzNN42dcNIaDFnG1utXGjRgE=
=Aw/G
-----END PGP SIGNATURE-----

--9OLtDuQbpDP0jtNd--
