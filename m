Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC184FA720
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241573AbiDILSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239277AbiDILSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:18:31 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2136349;
        Sat,  9 Apr 2022 04:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=4Lj1Z+jCyu6vB/7iyhsi5yS1LxWUMWWsBX88IFcpP4k=; b=SrecTcYcEhY26rYR5koREmj7jT
        gmksjVep7HDC+HsaSmLlbAmgbvSd2X4THoYBoA7aSQPgrneJ/vB9C6w8CUNHm7533hbRsBfzccSgY
        gHF2Jcl4Rxh+zgTucUqRR52vbjALaEO9ppi4kW/6a7gNHWWWh1OltzW87nDKho8MRDQ0uJau+/wTN
        t5AIJDsJkzSaO5wOXNtAwRuO3Pwvq0H4g2UitEUNinhzKikoqdQ2EnUidtQi6OE0jF64BGsB8jNsO
        VtX9LDtxUYoMLUtlxXv6iiO3gaEUzN8CoWgOixP3LtiRdK6eoAiqRSY5PfDKiAm6O3Sr64I7PRrdc
        A4+xnEJChkhY+wulGIXBGvjlPoUnM3UCRwkMWHnwEWCLpQZVMkLqtVKK8ZWpl/lfch8HCRLbDBTB6
        m/XpsGlgX3X2FiTTMJpzc1fDVEatQcWTdR4AA70c8mt96m3gZK8eMJTqwK5GxQmyIKyu2ZQr/WFlq
        YkJ8/gZu2jW1eRo2orDldo8ziGO5iB7cCyU/8my4LHSlbHwnaaZbvciEgXB+ItIn8TAGHI4IhtA48
        9JPe+e1eumlZ2Vwg/93ZoWHBWEKPZHeWLuoup+G7IYK+GYQ1pTdPw9E+8WFo51kke1YkIJH0HfQt6
        FlUVIvuSGG7ESBasUlPcGUp+R59S4lN/+Veh5BJRE=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>, Greg Kurz <groug@kaod.org>
Subject: Re: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie detected)
Date:   Sat, 09 Apr 2022 13:16:11 +0200
Message-ID: <9591612.lsmsJCMaJN@silver>
In-Reply-To: <3791738.ukkqOL8KQD@silver>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <Yj8WkjT+MsdFIfwr@codewreck.org> <3791738.ukkqOL8KQD@silver>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mittwoch, 30. M=E4rz 2022 14:21:16 CEST Christian Schoenebeck wrote:
> I made some tests & benchmarks regarding the fs-cache issue of 9p, running
> different kernel versions and kernel configurations in comparison.
[...]
> Case  Linux kernel version           .config  msize    cache  duration  h=
ost cpu  errors/warnings
>
> A)    5.17.0+[2] + msize patches[1]  debug    4186112  mmap   20m 40s   ~=
80%      none
> B)    5.17.0+[2] + msize patches[1]  debug    4186112  loose  31m 28s   ~=
35%      several errors (compilation completed)
> C)    5.17.0+[2] + msize patches[1]  debug    507904   mmap   20m 25s   ~=
84%      none
> D)    5.17.0+[2] + msize patches[1]  debug    507904   loose  31m 2s    ~=
33%      several errors (compilation completed)
> E)    5.17.0+[2]                     debug    512000   mmap   23m 45s   ~=
75%      none
> F)    5.17.0+[2]                     debug    512000   loose  32m 6s    ~=
31%      several errors (compilation completed)
> G)    5.17.0+[2]                     release  512000   mmap   23m 18s   ~=
76%      none
> H)    5.17.0+[2]                     release  512000   loose  32m 33s   ~=
31%      several errors (compilation completed)
> I)    5.17.0+[2] + msize patches[1]  release  4186112  mmap   20m 30s   ~=
83%      none
> J)    5.17.0+[2] + msize patches[1]  release  4186112  loose  31m 21s   ~=
31%      several errors (compilation completed)
> K)    5.10.84                        release  512000   mmap   39m 20s   ~=
80%      none
> L)    5.10.84                        release  512000   loose  13m 40s   ~=
55%      none
[...]
> About the errors: I actually already see errors with cache=3Dloose and re=
cent
> kernel version just when booting the guest OS. For these tests I chose so=
me
> sources which allowed me to complete the build to capture some benchmark =
as
> well, I got some "soft" errors with those, but the build completed at lea=
st.
> I had other sources OTOH which did not complete though and aborted with
> certain invalid file descriptor errors, which I obviously could not use f=
or
> those benchmarks here.

I used git-bisect to identify the commit that broke 9p behaviour, and it is
indeed this one:

commit eb497943fa215897f2f60fd28aa6fe52da27ca6c (HEAD, refs/bisect/bad)
Author: David Howells <dhowells@redhat.com>
Date:   Tue Nov 2 08:29:55 2021 +0000

    9p: Convert to using the netfs helper lib to do reads and caching
   =20
    Convert the 9p filesystem to use the netfs helper lib to handle readpag=
e,
    readahead and write_begin, converting those into a common issue_op for =
the
    filesystem itself to handle.  The netfs helper lib also handles reading
    from fscache if a cache is available, and interleaving reads from both
    sources.
   =20
    This change also switches from the old fscache I/O API to the new one,
    meaning that fscache no longer keeps track of netfs pages and instead d=
oes
    async DIO between the backing files and the 9p file pagecache.  As a pa=
rt
    of this change, the handling of PG_fscache changes.  It now just means =
that
    the cache has a write I/O operation in progress on a page (PG_locked
    is used for a read I/O op).
   =20
    Note that this is a cut-down version of the fscache rewrite and does not
    change any of the cookie and cache coherency handling.
   =20
    Changes
    =3D=3D=3D=3D=3D=3D=3D
    ver #4:
      - Rebase on top of folios.
      - Don't use wait_on_page_bit_killable().
   =20
    ver #3:
      - v9fs_req_issue_op() needs to terminate the subrequest.
      - v9fs_write_end() needs to call SetPageUptodate() a bit more often.
      - It's not CONFIG_{AFS,V9FS}_FSCACHE[1]
      - v9fs_init_rreq() should take a ref on the p9_fid and the cleanup sh=
ould
        drop it [from Dominique Martinet].
   =20
    Signed-off-by: David Howells <dhowells@redhat.com>
    Reviewed-and-tested-by: Dominique Martinet <asmadeus@codewreck.org>
    cc: v9fs-developer@lists.sourceforge.net
    cc: linux-cachefs@redhat.com
    Link: https://lore.kernel.org/r/YUm+xucHxED+1MJp@codewreck.org/ [1]
    Link: https://lore.kernel.org/r/163162772646.438332.1632377320585505353=
5.stgit@warthog.procyon.org.uk/ # rfc
    Link: https://lore.kernel.org/r/163189109885.2509237.715366892450339917=
3.stgit@warthog.procyon.org.uk/ # rfc v2
    Link: https://lore.kernel.org/r/163363943896.1980952.122652730464941968=
9.stgit@warthog.procyon.org.uk/ # v3
    Link: https://lore.kernel.org/r/163551662876.1877519.147063916955532041=
56.stgit@warthog.procyon.org.uk/ # v4
    Link: https://lore.kernel.org/r/163584179557.4023316.110897623046576443=
42.stgit@warthog.procyon.org.uk # rebase on folio
    Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

So Linux kernel v5.15 is fine, v5.16 is broken.

Best regards,
Christian Schoenebeck



