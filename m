Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21A954DE8E
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359739AbiFPKBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiFPKBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:01:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F5CD5C871
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655373703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vjP7ap924J9OBjfY9i29fgpQAqGsTOPIG54R1q4KrOk=;
        b=UmD0Fol4TGQbY14tvVyc9LZHERfc6vvvgiU5Uf6tjYicJVI5PwPB+ssokVhm46k+xwBBDy
        cHrI102fPfjvnzDxS9QaF97+lTIfKlvY9g0SVBhbrtm8X01FRNJD/cDw8kaD9Mobj5UTeP
        o/xKp7QYRqz8MBfvEPSLhWQXIyzZ/g8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-4rz-bdwHO7q0WY6mXoA4fA-1; Thu, 16 Jun 2022 06:01:40 -0400
X-MC-Unique: 4rz-bdwHO7q0WY6mXoA4fA-1
Received: by mail-qk1-f200.google.com with SMTP id k13-20020a05620a414d00b006a6e4dc1dfcso1164363qko.19
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:01:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vjP7ap924J9OBjfY9i29fgpQAqGsTOPIG54R1q4KrOk=;
        b=nEKZ0Zg8PUZGTNxP+3P4bSWdFY5TPRnAqSeZG+kf16vN1DYRZka5zm7hXa8x4kIwdd
         YROhU7lMQ/4Bm+SujkYtjvLi+oZPzP0/7Va+ABiPwHdJiBz8Oja4CdAH42xj0xjBPIjz
         DZYZ7GmxfLcBRBrRQH2jeTMRKetAXttTzB9vKaZetawnWqXQ6SV/1iF1K7IEQzAU18tH
         AFXqEPYBfigcaLsUhAwSZG0qiafFE14n97m80xWKeUBwtXjb4tY/VESlUGMI7ts6GEXc
         glFTq1urBARkxLziGCZ+Mfnn2oq6f21FVRPYltB/MgQ4nfjvMBm0S3nGSDCKMmuz2NTK
         zkjw==
X-Gm-Message-State: AJIora/MSgXmn/C6VZ4JcjDUgui4C0jgLoncVmC0xnlGBGc+buc+LtIr
        1+TeMIBQgN3pdF+zvePxOfdDmfXduOY622ufF//JdrZG5bU0v4y1ppaGTiqOtOfklL8cmVujKKj
        d2lJAwRnMjRhM+PY+
X-Received: by 2002:ac8:7d8e:0:b0:304:eed1:d6ec with SMTP id c14-20020ac87d8e000000b00304eed1d6ecmr3184118qtd.590.1655373699908;
        Thu, 16 Jun 2022 03:01:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uMcNFTRDtAtpgMnCXNSMIUYnmcE2szBt8ThbvIHQc+4eMXeA4oONdmGd6PIBKWrATwkuD3fg==
X-Received: by 2002:ac8:7d8e:0:b0:304:eed1:d6ec with SMTP id c14-20020ac87d8e000000b00304eed1d6ecmr3184104qtd.590.1655373699653;
        Thu, 16 Jun 2022 03:01:39 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id k20-20020a05620a415400b006a6f1c30701sm1431078qko.115.2022.06.16.03.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 03:01:38 -0700 (PDT)
Message-ID: <2271ed3c6cbc3cd65680734107d773ee22ccfb3d.camel@redhat.com>
Subject: Re: [PATCH net] Revert "net: Add a second bind table hashed by port
 and address"
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        Joanne Koong <joannelkoong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Date:   Thu, 16 Jun 2022 12:01:36 +0200
In-Reply-To: <CANn89i+Gf_xbz_df21QSM8ddjKkFfk1h4Y=p4vHroPRAz0ZYrw@mail.gmail.com>
References: <20220615193213.2419568-1-joannelkoong@gmail.com>
         <CANn89i+Gf_xbz_df21QSM8ddjKkFfk1h4Y=p4vHroPRAz0ZYrw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-15 at 23:24 -0700, Eric Dumazet wrote:
> On Wed, Jun 15, 2022 at 12:32 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> > 
> > This reverts:
> > 
> > commit d5a42de8bdbe ("net: Add a second bind table hashed by port and address")
> > commit 538aaf9b2383 ("selftests: Add test for timing a bind request to a port with a populated bhash entry")
> > Link: https://lore.kernel.org/netdev/20220520001834.2247810-1-kuba@kernel.org/
> > 
> > There are a few things that need to be fixed here:
> > * Updating bhash2 in cases where the socket's rcv saddr changes
> > * Adding bhash2 hashbucket locks
> > 
> > Links to syzbot reports:
> > https://lore.kernel.org/netdev/00000000000022208805e0df247a@google.com/
> > https://lore.kernel.org/netdev/0000000000003f33bc05dfaf44fe@google.com/
> > 
> > Fixes: d5a42de8bdbe ("net: Add a second bind table hashed by port and address")
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> 
> 
> Do we really need to remove the test ? It is a benchmark, and should
> not 'fail' on old kernels.

I agree it's nice to keep the self-test alive.

Side notes, not strictly related to the revert: the self test is not
currently executed by `make run_tests` and requires some additional
setup: ulimit -n <high number>, 2001:db8:0:f101::1 being a locally
available address, and a mandatory command line argument.

@Joanne: you should additionally provide a wrapper script to handle the
above and update TEST_PROGS accordingly. As for this revert, could you
please re-post it touching the kernel code only?

Thanks,

Paolo

