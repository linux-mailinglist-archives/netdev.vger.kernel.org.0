Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E066DA6E5
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238839AbjDGBXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjDGBXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:23:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758947EFA;
        Thu,  6 Apr 2023 18:23:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1093464C44;
        Fri,  7 Apr 2023 01:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F84C433D2;
        Fri,  7 Apr 2023 01:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680830633;
        bh=KP6J4TIEWNnlWFbNn9M+ajMLsX2V/LxB0fAqKUi+V+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lFNSMoI0LnS3z1ZsKSHrFGA3jXaUhxKuLm53PxkE5VmSuzw4CtjbsThhMkk6BklZr
         yb4bldaEsZhP6P5+GrlCaDwuQ5GZZjkUTt01sPs48VzEpLpA0w9xmSeQ06SAM5t43f
         Ti6+ThbSaeCbybM2ElokAAYnVmqGxVz4VW1yW3b/bXsgBNAfPigk2uwBFgARFgDDdT
         TgM4AkekSpABcFwQ8ZKm4j4WglqmShPZCGWodAVXb3OjKPwix2XH2d0VDWrUMgvpiv
         qbA4eiLgjOGKXR0TSCzRbatlYrfCf5wCiuciK2ymb10NvbuN0qtUEQXUc74KJJU3fu
         pgBZXKXtZSmtg==
Date:   Thu, 6 Apr 2023 18:23:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Vernet <void@manifault.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the
 verifier.
Message-ID: <20230406182351.532edf53@kernel.org>
In-Reply-To: <CAADnVQLOMa=p2m++uTH1i5odXrO5mF9Y++dJZuZyL3gC3MEm0w@mail.gmail.com>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
        <20230404145131.GB3896@maniforge>
        <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
        <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com>
        <20230404185147.17bf217a@kernel.org>
        <CAEf4BzY3-pXiM861OkqZ6eciBJnZS8gsBL2Le2rGiSU64GKYcg@mail.gmail.com>
        <20230405111926.7930dbcc@kernel.org>
        <CAADnVQLhLuB2HG4WqQk6T=oOq2dtXkwy0TjQbnxa4cVDLHq7bg@mail.gmail.com>
        <20230406084217.44fff254@kernel.org>
        <CAADnVQLOMa=p2m++uTH1i5odXrO5mF9Y++dJZuZyL3gC3MEm0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Apr 2023 18:17:57 -0700 Alexei Starovoitov wrote:
> On Thu, Apr 6, 2023 at 8:42=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
> > > Yeah. If only...
> > > I'm exclusively using -c.
> > > -M only works with -s, but I couldn't make -s -M work either.
> > > Do you pass the series as a number? =20
> >
> > Yes, it copy just the numerical ID into the terminal.
> > =20
> > > but then series_json=3D$(curl -s $srv/series/$1/) line
> > > doesn't look right, since it's missing "/mbox/" ? =20
> >
> > That's loading JSON from the patchwork's REST API. =20
>=20
> This line still doesn't work for me.
> curl -s https://patchwork.kernel.org/series/736654/
> returns:
> The page URL requested (<code>/series/736654/</code>) does not exist.
>=20
> while
> curl -s https://patchwork.kernel.org/series/736654/mbox/
> returns proper mbox format.

Check if your git config is right:

$ git config --get pw.server
https://patchwork.kernel.org/api/1.1/

that's where $srv comes from

