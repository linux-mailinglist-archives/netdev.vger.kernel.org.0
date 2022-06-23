Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB40556FD9
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 03:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbiFWB1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 21:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbiFWB1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 21:27:46 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40673DA73;
        Wed, 22 Jun 2022 18:27:45 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cv13so14736492pjb.4;
        Wed, 22 Jun 2022 18:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=8VtBJj3dwIr7vdto3kime56JLy8UxuXRGHD/jLDfBZ8=;
        b=ACUnfB7TcKfLAfJBfhcaPF+f78pJ9pZvYRIBSMYZXztjinI+e3PAkxTmUkZA6BMhVy
         lgzJny9JTEHKSWk9DfJ+HdJje00DhI4FEKsaNqxPSuxpF+kh5PkylT0FN9Hi5gJT5sgY
         A2ehlFQ3qbGmHAGSgTffQCBlBHRL4om5Hz6C+GGXlC2FijwZFpjzOECseQ5john2M5Ke
         Hi3bgDVyFhf0FFqdw/ZmZ+UileflvIkPlLgCs4a+hv6I8k1CYjYUE8BCgCE9EgqWiYu1
         Z39sWXepIbSjvYkySf1VSYp7yPJfUtiwtIREkR41TXjgkjuPafjv5BItyAT8At0mkmEX
         +fRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=8VtBJj3dwIr7vdto3kime56JLy8UxuXRGHD/jLDfBZ8=;
        b=i2AMGT1IVUFvkmOC4f7xvnG4eMdIp0hGjA7H/YbiQr9JgsTRHWrLgNyHOUn+K8f0Tb
         c7xaHOI/KRQ+Rk1H8M5ZATIZ6sS6gFksbla/kWlKVtxG2WmP//UQKuLhCAZXDwaZ7i9C
         pWQvgTTU3ygw0I8iaQhirS/TKCIw1SFI1llqoxIhb5yXF3tMQ4cL9r6D0ZLNdXqH3CFW
         KFSpKSWXyo+78vJbnWGS2cWOP0q+k0hzyiecZamj8pdb5+vdvVOrF5boXNjqQsnvG4Sy
         uis9tpCloG7GBm+FLC/jmNcRjZK+Mg/jb1GPO2kPX8MtWeQXSJsbjUnF7Oan0Bg1e0LS
         Ro/Q==
X-Gm-Message-State: AJIora8918jxl0Q2GOOl8jkXlHbPWwEAEIKIXmgdWTpMWQzXYLehCqXS
        +yuZmrIhO/eO84MGT1wWmNw=
X-Google-Smtp-Source: AGRyM1tTibF5bOTcCSW3Nh3zCY7nikJHhxnA1qVR2f6DefieHghgXDPNZl7ycJ1Ll00eb0KgjuQ9rg==
X-Received: by 2002:a17:902:ca83:b0:16a:3317:b5c1 with SMTP id v3-20020a170902ca8300b0016a3317b5c1mr13019955pld.34.1655947665102;
        Wed, 22 Jun 2022 18:27:45 -0700 (PDT)
Received: from localhost ([98.97.116.244])
        by smtp.gmail.com with ESMTPSA id a13-20020a1709027e4d00b0015e8d4eb26csm13522728pln.182.2022.06.22.18.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 18:27:44 -0700 (PDT)
Date:   Wed, 22 Jun 2022 18:27:38 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kafai@fb.com" <kafai@fb.com>, "yhs@fb.com" <yhs@fb.com>
Cc:     "dhowells@redhat.com" <dhowells@redhat.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Message-ID: <62b3c18ab4dda_6a3b220812@john.notmuch>
In-Reply-To: <03b67c7a6161428c9ff8a5dde0450402@huawei.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-4-roberto.sassu@huawei.com>
 <62b245e22effa_1627420871@john.notmuch>
 <03b67c7a6161428c9ff8a5dde0450402@huawei.com>
Subject: RE: [PATCH v5 3/5] bpf: Add bpf_verify_pkcs7_signature() helper
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roberto Sassu wrote:
> > From: John Fastabend [mailto:john.fastabend@gmail.com]
> > Sent: Wednesday, June 22, 2022 12:28 AM
> > Roberto Sassu wrote:
> > > Add the bpf_verify_pkcs7_signature() helper, to give eBPF security modules
> > > the ability to check the validity of a signature against supplied data, by
> > > using user-provided or system-provided keys as trust anchor.
> > >
> > > The new helper makes it possible to enforce mandatory policies, as eBPF
> > > programs might be allowed to make security decisions only based on data
> > > sources the system administrator approves.
> > >
> > > The caller should provide both the data to be verified and the signature as
> > > eBPF dynamic pointers (to minimize the number of parameters).
> > >
> > > The caller should also provide a keyring pointer obtained with
> > > bpf_lookup_user_key() or, alternatively, a keyring ID with values defined
> > > in verification.h. While the first choice gives users more flexibility, the
> > > second offers better security guarantees, as the keyring selection will not
> > > depend on possibly untrusted user space but on the kernel itself.
> > >
> > > Defined keyring IDs are: 0 for the primary keyring (immutable keyring of
> > > system keys); 1 for both the primary and secondary keyring (where keys can
> > > be added only if they are vouched for by existing keys in those keyrings);
> > > 2 for the platform keyring (primarily used by the integrity subsystem to
> > > verify a kexec'ed kerned image and, possibly, the initramfs signature).
> > >
> > > Note: since the keyring ID assignment is understood only by
> > > verify_pkcs7_signature(), it must be passed directly to the corresponding
> > > helper, rather than to a separate new helper returning a struct key pointer
> > > with the keyring ID as a pointer value. If such pointer is passed to any
> > > other helper which does not check its validity, an illegal memory access
> > > could occur.
> > >
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > Reported-by: kernel test robot <lkp@intel.com> (cast warning)
> > > ---
> > >  include/uapi/linux/bpf.h       | 17 +++++++++++++++
> > >  kernel/bpf/bpf_lsm.c           | 39 ++++++++++++++++++++++++++++++++++
> > >  tools/include/uapi/linux/bpf.h | 17 +++++++++++++++
> > >  3 files changed, 73 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 7bbcf2cd105d..524bed4d7170 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -5339,6 +5339,22 @@ union bpf_attr {
> > >   *		bpf_lookup_user_key() helper.
> > >   *	Return
> > >   *		0
> > > + *
> > > + * long bpf_verify_pkcs7_signature(struct bpf_dynptr *data_ptr, struct
> > bpf_dynptr *sig_ptr, struct key *trusted_keys, unsigned long keyring_id)
> > > + *	Description
> > > + *		Verify the PKCS#7 signature *sig* against the supplied *data*
> > > + *		with keys in *trusted_keys* or in a keyring with ID
> > > + *		*keyring_id*.
> > 
> > Would be nice to give precedence here so that its obvious order between
> > trusted_keys and keyring_id.
> 
> Did you mean to add at the end of the sentence:
> 
> or in a keyring with ID *keyring_id*, if *trusted_keys* is NULL.

Yes something like this.
