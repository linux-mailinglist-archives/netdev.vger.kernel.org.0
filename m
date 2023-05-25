Return-Path: <netdev+bounces-5392-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E929E7110B8
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E99E1C20EDA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 667941C764;
	Thu, 25 May 2023 16:17:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C4319E7F
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 16:17:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BD2E5C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685031426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=38Y9fkp4Zp4Du4P0IInC6xQsvin4b9pasbkNei8e9rs=;
	b=N1HoU4ZP+5zFumrTkS5t8vWGKnUvwxhnBQstjPR+InK2FBJcXTH1u0wywkSepOjZev3NNa
	PjyAQzSOL7L28hdToLEIDWb+mIBipttZrnNP7OMN30DW5VTUbGxZKQGaJA5g2EShy6AZ7A
	YrXBK6f6cUwKsx+Yt9N9woNa6dBXQBs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-XXrNhEsmPImXOT5vL5Leig-1; Thu, 25 May 2023 12:17:04 -0400
X-MC-Unique: XXrNhEsmPImXOT5vL5Leig-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-510ddadbec6so2868281a12.3
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:17:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685031423; x=1687623423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=38Y9fkp4Zp4Du4P0IInC6xQsvin4b9pasbkNei8e9rs=;
        b=T0qGqzCKJNy4W41I9dE6yfJKwui2FieeNpSgL+n0LNvp5cpCVIh7PqerTvdk7vhS7v
         DZRVvv1mrstgqUCCo00nD1QvBHYTtfP5DeHQ08au70zcffrm7kXEF/NGWZSgX5WRZr8F
         QJmk4P1FXy4pviTsf5t05Vs+CttrZVWSPQZIxL24fRCj+kP7Eulp7u1M6tlKDxRM3K3J
         S2PiX7EjdohJVkFsrr0s8ukPp9BQe1juInkhG/xII+2wKI06qrG7GdXcDa//mduD/xhf
         YyOejRJZkzDs6qShQd+o4++lDApzET4e0WLmk4CaPfXbNQACOjNG8AGQ5FJQahxHvPlt
         7mQg==
X-Gm-Message-State: AC+VfDwyUFpJbJpMy5hXKNCKsBB9xAX3rLQaEhdLHIx1s9wkkiv4Ug7P
	LndXmC4soAuUozhG5YQoXNbGk0I1UNB9yVdJs/tQXiaXDvmGJsl2mwwjR/4q0k7FuqSetk1kbp4
	+TV66ZOd3ATGNPkgkO9ZOb5xr4aXpR5C9jh4KEu+ursM=
X-Received: by 2002:a17:907:1c8b:b0:949:cb6a:b6f7 with SMTP id nb11-20020a1709071c8b00b00949cb6ab6f7mr2495080ejc.56.1685031423220;
        Thu, 25 May 2023 09:17:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ51XYG6Iz6rWQkVAm4rcAmSD1vipk3KVoBUrFx2NZDObKb52IdUNbS7NF1/+cFjTv9YtrjJBkxzom/d4TiIhTE=
X-Received: by 2002:a17:907:1c8b:b0:949:cb6a:b6f7 with SMTP id
 nb11-20020a1709071c8b00b00949cb6ab6f7mr2495043ejc.56.1685031422796; Thu, 25
 May 2023 09:17:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230523165932.8376-1-stephen@networkplumber.org>
 <20230523165932.8376-2-stephen@networkplumber.org> <ZG5SF/8CLymhAQsT@renaissance-vector>
 <20230524114451.2d014b03@hermes.local>
In-Reply-To: <20230524114451.2d014b03@hermes.local>
From: Andrea Claudi <aclaudi@redhat.com>
Date: Thu, 25 May 2023 18:16:51 +0200
Message-ID: <CAPpH65y84E1Jq=Y8CSTZNAnP-F9c-J=pBF-RPUnT9Um=gFOs2A@mail.gmail.com>
Subject: Re: [RFC 2/2] vxlan: make option printing more consistent
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 8:44=E2=80=AFPM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Wed, 24 May 2023 20:06:15 +0200
> Andrea Claudi <aclaudi@redhat.com> wrote:
>
> > Thanks Stephen for pointing this series out to me, I overlooked it due
> > to the missing "iproute" in the subject.
> >
> > I'm fine with the JSON result, having all params printed out is much
> > better than the current output.
> >
> > My main objection to this is the non-JSON output result. Let's compare
> > the current output with the one resulting from this RFC:
> >
> > $ ip link add type vxlan id 12
> > $ ip -d link show vxlan0
> > 79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode D=
EFAULT group default qlen 1000
> >     link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  a=
llmulti 0 minmtu 68 maxmtu 65535
> >     vxlan id 12 srcport 0 0 dstport 8472 ttl auto ageing 300 udpcsum no=
udp6zerocsumtx noudp6zerocsumrx addrgenmode eui64 numtxqueues 1 numrxqueues=
 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 65536 tso_max_segs 65=
535 gro_max_size 65536
> >
> > $ ip.new -d link show vxlan0
> > 79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode D=
EFAULT group default qlen 1000
> >     link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  a=
llmulti 0 minmtu 68 maxmtu 65535
> >     vxlan noexternal id 12 srcport 0 0 dstport 8472 learning noproxy no=
rsc nol2miss nol3miss ttl auto ageing 300 udp_csum noudp_zero_csum6_tx noud=
p_zero_csum6_rx noremcsum_tx noremcsum_rx addrgenmode eui64 numtxqueues 1 n=
umrxqueues 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 65536 tso_m=
ax_segs 65535 gro_max_size 65536
> >
> > In my opinion, the new output is much longer and less human-readable.
> > The main problem (besides intermixed boolean and numerical params) is
> > that we have a lot of useless info. If the ARP proxy is turned off,
> > what's the use of "noproxy" over there? Let's not print anything at all=
,
> > I don't expect to find anything about proxy in the output if I'm not
> > asking to have it. It seems to me the same can be said for all the
> > "no"-params over there.
> >
> > What I'm proposing is something along this line:
> >
> > +int print_color_bool_opt(enum output_type type,
> > +                      enum color_attr color,
> > +                      const char *key,
> > +                      bool value)
> > +{
> > +     int ret =3D 0;
> > +
> > +     if (_IS_JSON_CONTEXT(type))
> > +             jsonw_bool_field(_jw, key, value);
> > +     else if (_IS_FP_CONTEXT(type) && value)
> > +             ret =3D color_fprintf(stdout, color, "%s ", key);
> > +     return ret;
> > +}
> >
> > This should lead to no change in the JSON output w.r.t. this patch, and
> > to this non-JSON output
> >
> > 79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode D=
EFAULT group default qlen 1000
> >     link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  a=
llmulti 0 minmtu 68 maxmtu 65535
> >     vxlan id 12 srcport 0 0 dstport 8472 learning ttl auto ageing 300 u=
dp_csum addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gs=
o_max_segs 65535 tso_max_size 65536 tso_max_segs 65535 gro_max_size 65536
> >
> > that seems to me much more clear and concise.
> >
>
> The problem is that one of the options is now by default enabled.
> The current practice in iproute2 is that the output of the show command m=
ust match the equivalent
> command line used to create the device.  There were even some VPN's using=
 that.
> The proposed localbypass would have similar semantics.

That's true even before the "localbypass" option, since we already have
the "udpcsum" option enabled by default and printed in the current
non-JSON output. So we already have an output that does not match the
command line used to create the device.

>
> The learning option defaults to true, so either it has to be a special ca=
se or it needs to be
> printed only if false.
>
> Seems to me that if you ask for details in the output, that showing every=
thing is less surprising,
> even if it is overly verbose. But the user asked for the details, so show=
 them.
>

Fair point. However, I argue that if the user asks for details, we
should provide them in easy-to-read format, as far as possible, and
avoid to provide info of little use (for example, we don't print
"noalias" if there is no alias set).

As you say in your other email, there's a trend in growing the number
of options in vxlan. As we can do little about that, going down this path
can bring us to the point where finding an option can take much more
than a quick glance, resulting in a bad user experience.

Anyway, whatever you choose, I'm glad iproute2 will finally have some
guidelines about the output. :)

Regards,
Andrea


