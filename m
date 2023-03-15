Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65EEE6BABC8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbjCOJMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjCOJMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:12:09 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA8C22A0E
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:12:02 -0700 (PDT)
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 95AC83F216
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 09:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678871521;
        bh=P/BhQnodHQMuIve33sHtY7JZX2tmBx78/5+ZyMzFlMA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=lbv+AEqECO2i+EZGICugfrTrM1wSVn3Me0Gl7KAtwE3sGLC1ZNrCjVF7B3Eu5ijzg
         Gw2OGIRbo72OB0cVikx3zg8yYdAlvNbuRfgofAiFOedG7uEOQwmsU4QSmzcDqxxdOx
         iQdvg3r9npNEOkxoV4Y/AjsIgBEV4vZ7HlkGtzQOsGKlisCkIb3z3q/ZDImNSREZB4
         JvHFZREj/9pE2joRpdNAs49End5e0hGWe+5mkift29Err3FnNbcGCVlLRGdliF52px
         UsZtN+Hj+b4ZoiocKNonEpTu+9oxYZ6tjJiFju96uvmKY38nzdsuTN/OECWHVaU7S5
         YBDGpn25+OrmQ==
Received: by mail-oo1-f71.google.com with SMTP id l11-20020a4aa78b000000b005254a9621e1so4873010oom.8
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:12:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678871520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P/BhQnodHQMuIve33sHtY7JZX2tmBx78/5+ZyMzFlMA=;
        b=z1Y87CAIuIbDzSZjYjJqKL4QKG9TtgZlD0lAL+vgnvtkLNtAD8d9Ct0hAcIuXU6N5h
         O+TzLBguHAqYkJUGm7bXxH0L0w25N/csaa6Xa5acle0E69SLSdvH0DUfhX2HhPr6+Txk
         Eq6KaOEvxjdjsek6MR24RQXR2XfjMtrMQfQ6E63zZvqSukzvIC0/wJSPVK2EDwe8ueGe
         s4kUlGRswDYsSJVcr1KYPl0uUsElIu6CJd+qnrf8zEPxZrbCvVnf8G9WbQHsBZcvCOqO
         Ft7bIjl4d7NhuyDUx10I1H52W67ZQvv7c+tCtkfFXMeF7qtjRCu7/3hHenMws1dK8BxF
         8Jnw==
X-Gm-Message-State: AO0yUKWrPxAGeG+aq099sj8pNT3GNGzZpOamcZaKD+O5tesPqaTpvjFk
        aj6nG1EaDISpkv7s0m0uveIeZjC9nNS7c0cxR5ABW4PXwbvhZpHHKp5HW8FbK6V60iakmyjlzuo
        FKcKhakGqsF0FSWa6FlyTYzpUWiVbIz5BajY+xZjA9mo8i9Jp
X-Received: by 2002:a05:6870:1218:b0:177:96d4:bf93 with SMTP id 24-20020a056870121800b0017796d4bf93mr5306833oan.2.1678871520553;
        Wed, 15 Mar 2023 02:12:00 -0700 (PDT)
X-Google-Smtp-Source: AK7set8e97OC4fzgzSlY1mzs8HHQdq6rcv7FKmYgVe/AVZVt5b9E9bjKlrs7cdkkcFLs+XeGaRWXz469cDchZPbpw7M=
X-Received: by 2002:a05:6870:1218:b0:177:96d4:bf93 with SMTP id
 24-20020a056870121800b0017796d4bf93mr5306828oan.2.1678871520323; Wed, 15 Mar
 2023 02:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230307150030.527726-1-po-hsu.lin@canonical.com> <20230310160541.5ec7722a@kernel.org>
In-Reply-To: <20230310160541.5ec7722a@kernel.org>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Wed, 15 Mar 2023 17:11:44 +0800
Message-ID: <CAMy_GT8NkEMXFnZ73gLyfN3sxo3-Et6ScJLd80qh07zRuQdH=Q@mail.gmail.com>
Subject: Re: [PATCHv2] selftests: net: devlink_port_split.py: skip test if no
 suitable device available
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, idosch@mellanox.com,
        danieller@mellanox.com, petrm@mellanox.com, shuah@kernel.org,
        pabeni@redhat.com, edumazet@google.com, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 8:05=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Tue,  7 Mar 2023 23:00:30 +0800 Po-Hsu Lin wrote:
> >  def main(cmdline=3DNone):
> > +    test_ran =3D False
>
> Could you move this variable init right before the
>
>         for port in ports.if_names:
>
> line, and call it something like found_max_lanes ?
>
> >      parser =3D make_parser()
> >      args =3D parser.parse_args(cmdline)
> >
> > @@ -240,12 +264,9 @@ def main(cmdline=3DNone):
> >          stdout, stderr =3D run_command(cmd)
> >          assert stderr =3D=3D ""
> >
> > +        validate_devlink_output(json.loads(stdout))
> >          devs =3D json.loads(stdout)['dev']
> > -        if devs:
> > -            dev =3D list(devs.keys())[0]
> > -        else:
> > -            print("no devlink device was found, test skipped")
> > -            sys.exit(KSFT_SKIP)
> > +        dev =3D list(devs.keys())[0]
> >
> >      cmd =3D "devlink dev show %s" % dev
> >      stdout, stderr =3D run_command(cmd)
> > @@ -277,6 +298,11 @@ def main(cmdline=3DNone):
> >                  split_splittable_port(port, lane, max_lanes, dev)
> >
> >                  lane //=3D 2
> > +        test_ran =3D True
> > +
> > +    if not test_ran:
> > +        print("Test not started, no suitable device for the test")
>
> Then change the message to
>
>         f"Test not started, no port of device {dev} reports max_lanes"
>

Sure,
will update this in V3
Thanks for the feedback!

> > +        sys.exit(KSFT_SKIP)
> >
