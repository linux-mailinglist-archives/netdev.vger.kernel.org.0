Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D0A6B03A1
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 11:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjCHKDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 05:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCHKDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 05:03:14 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341E61D93A
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 02:03:07 -0800 (PST)
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4D01C41B65
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 10:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678269786;
        bh=TcoqL65GM7xxmY0Iiy4skPLD0tnvFATDCwzBl50q5+I=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=Detcu/W1H/u66gtLzFKJ3OwXxNZAYTNW5tTCYi+Xu6Jl+THS3kklSPPSfcTgx9HJE
         n7u2FSC/IR58we9/yISPut0h5IIhI1oVwkTs8LFR6O+4mrmMv28iD7Dcr703lhJd1K
         4D84Zmc9IYQ6RgGAiMaI85/LwadfvcF4K3/rWEtfBHGEOL5CU3CFqJ9nfco+7RIfk+
         9U7MSwTKfAoVEYYSC0+mLVGfiKwvFMdUTTtf2GbRzkVW0PhY75dOGZbT4pV6+LXBzP
         etPF1MGmKqqxPlLBLYQP0R8cnbJvSNjYG3fne3Hcy5e4RR4ht6qFZrxnr7r902rmq+
         LcFrP5bZyFXvQ==
Received: by mail-oo1-f72.google.com with SMTP id t2-20020a4ad0a2000000b00517879b32dfso4920201oor.22
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 02:03:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678269785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TcoqL65GM7xxmY0Iiy4skPLD0tnvFATDCwzBl50q5+I=;
        b=C63MitCQOSGJkMjstIRqYoyJs4EXVLXDw2Z0A9u+ADDKCooqFNjvX1giR/YxlJi+NT
         W4t//8lHelgI1ewt78saUJZv9zkrzKbT1koKlNeo0AUeoUxuCGWp64KX4sRkPMCQeLPt
         b/VPSELQi6k2SFrzaKL1ic5srylkmy/RkSKmV3Oew9D2z8ShhZ3XIs49lqUvGWXN+1bP
         40wSoDNGpBUpWd0NSJmXE8MxI7yuGhKVVMStNuqmllvZRBwBVZBS0/asprhnXHndDoPQ
         B9bDBUHd/I2q6kBy4GADI56xvt7LPPb1aAK6Ky2aEnfm6AqhWbr4sLOAruy7v1Vk3TT/
         x/hw==
X-Gm-Message-State: AO0yUKW7M8cA/wl71acoyuuIpna06oB7d+99uP0YQGIDIOFpLzBVbhRG
        JDjXCDRGVxM6rHeCYjR9gI42rbOS39TeCfXQ6CGGl9QFMTTlgzWXxmD6Rrmd3rTjMzsunPt514t
        /cjC3ealHQECKr07LNhdescE7W1tX8bygJHqlc/BLCPWQRBqc
X-Received: by 2002:a05:6870:d346:b0:176:42a5:a544 with SMTP id h6-20020a056870d34600b0017642a5a544mr5041314oag.2.1678269785263;
        Wed, 08 Mar 2023 02:03:05 -0800 (PST)
X-Google-Smtp-Source: AK7set/rrxkpYmldQbkjsH+aqtmbvnADinYJ3IA6vjRlLPTAKktc6w1MXBujxHZsR32pBxuvK3COpwN6xQq6zhKYfmk=
X-Received: by 2002:a05:6870:d346:b0:176:42a5:a544 with SMTP id
 h6-20020a056870d34600b0017642a5a544mr5041308oag.2.1678269784978; Wed, 08 Mar
 2023 02:03:04 -0800 (PST)
MIME-Version: 1.0
References: <20230307150030.527726-1-po-hsu.lin@canonical.com> <20230307170219.4699af9b@kernel.org>
In-Reply-To: <20230307170219.4699af9b@kernel.org>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Wed, 8 Mar 2023 18:02:26 +0800
Message-ID: <CAMy_GT8fdX2uUAM1j9Lzje+K5BnLH82dmx3CE=mGV9UqSRBWAg@mail.gmail.com>
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

On Wed, Mar 8, 2023 at 9:02=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Tue,  7 Mar 2023 23:00:30 +0800 Po-Hsu Lin wrote:
> > The `devlink -j port show` command output may not contain the "flavour"
> > key, an example from s390x LPAR with Ubuntu 22.10 (5.19.0-37-generic),
> > iproute2-5.15.0:
> >   {"port":{"pci/0001:00:00.0/1":{"type":"eth","netdev":"ens301"},
> >            "pci/0001:00:00.0/2":{"type":"eth","netdev":"ens301d1"},
> >            "pci/0002:00:00.0/1":{"type":"eth","netdev":"ens317"},
> >            "pci/0002:00:00.0/2":{"type":"eth","netdev":"ens317d1"}}}
> >
> > This will cause a KeyError exception.
>
> I looked closer and I don't understand why the key is not there.
> Both 5.19 kernel should always put this argument out, and 5.15
> iproute2 should always interpret it.
>
> Am I looking wrong? Do you see how we can get a dump with no flavor?
>
> I worry that this is some endianness problem, and we just misreport
> stuff on big-endian.
>
> > Create a validate_devlink_output() to check for this "flavour" from
> > devlink command output to avoid this KeyError exception. Also let
> > it handle the check for `devlink -j dev show` output in main().
> >
> > Apart from this, if the test was not started because of any reason
> > (e.g. "lanes" does not exist, max lanes is 0 or the flavour of the
> > designated device is not "physical" and etc.) The script will still
> > return 0 and thus causing a false-negative test result.
> >
> > Use a test_ran flag to determine if these tests were skipped and
> > return KSFT_SKIP to make it more clear.
> >
> > V2: factor out the skip logic from main(), update commit message and
> >     skip reasons accordingly.
> > Link: https://bugs.launchpad.net/bugs/1937133
> > Fixes: f3348a82e727 ("selftests: net: Add port split test")
> > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> > ---
> >  tools/testing/selftests/net/devlink_port_split.py | 36 +++++++++++++++=
++++----
> >  1 file changed, 31 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/net/devlink_port_split.py b/tools/=
testing/selftests/net/devlink_port_split.py
> > index 2b5d6ff..749606c 100755
> > --- a/tools/testing/selftests/net/devlink_port_split.py
> > +++ b/tools/testing/selftests/net/devlink_port_split.py
> > @@ -59,6 +59,8 @@ class devlink_ports(object):
> >          assert stderr =3D=3D ""
> >          ports =3D json.loads(stdout)['port']
> >
> > +        validate_devlink_output(ports, 'flavour')
>
> If it's just a matter of kernel/iproute2 version we shouldn't need to
> check here again?
>
> >          for port in ports:
> >              if dev in port:
> >                  if ports[port]['flavour'] =3D=3D 'physical':
> > @@ -220,6 +222,27 @@ def split_splittable_port(port, k, lanes, dev):
> >      unsplit(port.bus_info)
> >
> >
> > +def validate_devlink_output(devlink_data, target_property=3DNone):
> > +    """
> > +    Determine if test should be skipped by checking:
> > +      1. devlink_data contains values
> > +      2. The target_property exist in devlink_data
> > +    """
> > +    skip_reason =3D None
> > +    if any(devlink_data.values()):
> > +        if target_property:
> > +            skip_reason =3D "{} not found in devlink output, test skip=
ped".format(target_property)
> > +            for key in devlink_data:
> > +                if target_property in devlink_data[key]:
> > +                    skip_reason =3D None
> > +    else:
> > +        skip_reason =3D 'devlink output is empty, test skipped'
> > +
> > +    if skip_reason:
> > +        print(skip_reason)
> > +        sys.exit(KSFT_SKIP)
>
> Looks good, so..
>
> >  def make_parser():
> >      parser =3D argparse.ArgumentParser(description=3D'A test for port =
splitting.')
> >      parser.add_argument('--dev',
> > @@ -231,6 +254,7 @@ def make_parser():
> >
> >
> >  def main(cmdline=3DNone):
> > +    test_ran =3D False
>
> I don't think we need the test_ran tracking any more?
We still need this here to check if the test was actually started.

Take the following output for example (ARM64 server with Mellanox
Ethernet controller, running Ubuntu 22.10 5.19.0-35):
$ devlink port show
pci/0000:01:00.0/65535: type eth netdev enp1s0f0 flavour physical port
0 splittable false
pci/0000:01:00.1/131071: type eth netdev enp1s0f1 flavour physical
port 1 splittable false
There is no "lanes" attribute here, thus the max_lanes in main() will
be 0. The test won't be started at all but returns 0.


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
> > +        sys.exit(KSFT_SKIP)
> >
> >
> >  if __name__ =3D=3D "__main__":
>
