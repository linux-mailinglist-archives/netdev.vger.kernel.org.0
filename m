Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D4964C75A
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbiLNKpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238031AbiLNKpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:45:12 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76851233B6;
        Wed, 14 Dec 2022 02:45:11 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id b2so43474898eja.7;
        Wed, 14 Dec 2022 02:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OHfvtZx7J+AGz2b35HpLL3MUBEQxatDXlprz48ET82s=;
        b=I9xcnXwo20NQMMGueN9+041BCH/sB8hRSsVuvJtTLc8hpslnIX4SMDfs8Zh5rhIiTI
         21YPjRwehnmpNxYGJJlKeK8Nm2BIX7XBfTtVv1Js7DqEv8J3s7pYAzSStNxFFsE9mfHj
         j5ImOzBUztgoZK/LaHw4RUOryeUxHKJ7nZCxFLzkPidpxjI9yRQ6vLCAHLg1mnzfeINu
         N7L7pCo6+nYf19QOPM56a2Q5K6WGVOPPwpJX3wsyfk/eAtCCoEC71DGO7hAE0qQuE7WR
         NZwUHpTz61k0zxho+mqWaX9AL6y7ZXUiufJboKHM3TuwNP2E94CS81OG0b28PMquHF28
         YpVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OHfvtZx7J+AGz2b35HpLL3MUBEQxatDXlprz48ET82s=;
        b=FGx/VjU8GnFdQUd+O50eMLwV7ydhqMQFVNLfjGgFpEx/3UoWs/pk+N6b39+DIf74dq
         zxcnCu6XEhBsbxIvYW9bBOztM44V3AFvb/ARgfO1Pcz06n6GTzds3qwlLjPaFug+dJay
         0iNgsWDMIGNiOa1SElXRZMf3JcgipXa6Oax0JSWKboMU0A8GJTv7APnDqfILJeYoL9o7
         aqhd2y9piQb+IZcnMp4iZ6MfXRv5QXFpr0hqc34JBcV4KH01sRq3voPWOs7DGvGIjSuj
         E6AmAKl7oNLKgBnuS70HXsaXPjuLKsW1e6tHa1WRWCjYlS3Z/XDndWUbP4zBCQ8YALf8
         y42A==
X-Gm-Message-State: ANoB5pnPAPkVobKmDb9S+w7GgiUivBBLx2XhjC+chkv5nRIyVzItvTyZ
        ezVoGbbotHZtKWbmuSse17tksMWSBcM4bfcWzlE=
X-Google-Smtp-Source: AA0mqf7YkgvM2233NvvybJvV6I19g6m9EePTwNhXArscZcVSarjAmzIGpYmAw+6xFsyC/sU4+kV9F0bSJQXOTHd7f78=
X-Received: by 2002:a17:906:6c91:b0:7c1:4c57:4726 with SMTP id
 s17-20020a1709066c9100b007c14c574726mr1286040ejr.488.1671014709938; Wed, 14
 Dec 2022 02:45:09 -0800 (PST)
MIME-Version: 1.0
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
 <20221206090826.2957-9-magnus.karlsson@gmail.com> <Y5c4eD2mRT/qHUi4@boxer>
In-Reply-To: <Y5c4eD2mRT/qHUi4@boxer>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 14 Dec 2022 11:44:57 +0100
Message-ID: <CAJ8uoz1dpKSG4bAq2d-1ckGumBhzcQX3DjpYBmOznOGEpZLCww@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/15] selftests/xsk: remove namespaces
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        yhs@fb.com, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 3:20 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Dec 06, 2022 at 10:08:19AM +0100, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Remove the namespaces used as they fill no function. This will
> > simplify the code for speeding up the tests in the following commits.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/testing/selftests/bpf/test_xsk.sh    | 33 +++++++----------
> >  tools/testing/selftests/bpf/xsk_prereqs.sh | 12 ++-----
> >  tools/testing/selftests/bpf/xskxceiver.c   | 42 +++-------------------
> >  tools/testing/selftests/bpf/xskxceiver.h   |  3 --
> >  4 files changed, 19 insertions(+), 71 deletions(-)
> >
>
> (...)
>
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> > index 72578cebfbf7..0aaf2f0a9d75 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.c
> > +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > @@ -55,12 +55,11 @@
> >   * Flow:
> >   * -----
> >   * - Single process spawns two threads: Tx and Rx
> > - * - Each of these two threads attach to a veth interface within their assigned
> > - *   namespaces
> > - * - Each thread Creates one AF_XDP socket connected to a unique umem for each
> > + * - Each of these two threads attach to a veth interface
> > + * - Each thread creates one AF_XDP socket connected to a unique umem for each
> >   *   veth interface
> > - * - Tx thread Transmits 10k packets from veth<xxxx> to veth<yyyy>
> > - * - Rx thread verifies if all 10k packets were received and delivered in-order,
> > + * - Tx thread Transmits a number of packets from veth<xxxx> to veth<yyyy>
> > + * - Rx thread verifies if all packets were received and delivered in-order,
> >   *   and have the right content
> >   *
> >   * Enable/disable packet dump mode:
> > @@ -399,28 +398,6 @@ static void usage(const char *prog)
> >       ksft_print_msg(str, prog);
> >  }
> >
> > -static int switch_namespace(const char *nsname)
> > -{
> > -     char fqns[26] = "/var/run/netns/";
> > -     int nsfd;
> > -
> > -     if (!nsname || strlen(nsname) == 0)
> > -             return -1;
> > -
> > -     strncat(fqns, nsname, sizeof(fqns) - strlen(fqns) - 1);
> > -     nsfd = open(fqns, O_RDONLY);
> > -
> > -     if (nsfd == -1)
> > -             exit_with_error(errno);
> > -
> > -     if (setns(nsfd, 0) == -1)
> > -             exit_with_error(errno);
> > -
> > -     print_verbose("NS switched: %s\n", nsname);
> > -
> > -     return nsfd;
> > -}
> > -
> >  static bool validate_interface(struct ifobject *ifobj)
> >  {
> >       if (!strcmp(ifobj->ifname, ""))
> > @@ -438,7 +415,7 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
> >       opterr = 0;
> >
> >       for (;;) {
> > -             char *sptr, *token;
> > +             char *sptr;
> >
> >               c = getopt_long(argc, argv, "i:Dvb", long_options, &option_index);
> >               if (c == -1)
> > @@ -455,9 +432,6 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
> >
> >                       sptr = strndupa(optarg, strlen(optarg));
>
> Wasn't this strndupa needed only because of strsep usage?
> I feel that now you can just memcpy directly from optarg to ifobj->nsname.

Will fix.

> >                       memcpy(ifobj->ifname, strsep(&sptr, ","), MAX_INTERFACE_NAME_CHARS);
> > -                     token = strsep(&sptr, ",");
> > -                     if (token)
> > -                             memcpy(ifobj->nsname, token, MAX_INTERFACES_NAMESPACE_CHARS);
> >                       interface_nb++;
> >                       break;
> >               case 'D':
> > @@ -1283,8 +1257,6 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
> >       int ret, ifindex;
> >       void *bufs;
> >
> > -     ifobject->ns_fd = switch_namespace(ifobject->nsname);
> > -
> >       if (ifobject->umem->unaligned_mode)
> >               mmap_flags |= MAP_HUGETLB;
> >
> > @@ -1843,8 +1815,6 @@ static struct ifobject *ifobject_create(void)
> >       if (!ifobj->umem)
> >               goto out_umem;
> >
> > -     ifobj->ns_fd = -1;
> > -
> >       return ifobj;
> >
> >  out_umem:
> > @@ -1856,8 +1826,6 @@ static struct ifobject *ifobject_create(void)
> >
> >  static void ifobject_delete(struct ifobject *ifobj)
> >  {
> > -     if (ifobj->ns_fd != -1)
> > -             close(ifobj->ns_fd);
> >       free(ifobj->umem);
> >       free(ifobj->xsk_arr);
> >       free(ifobj);
>
> (...)
