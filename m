Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40F7572A77
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 02:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiGMAyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 20:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiGMAyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 20:54:02 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE00BEB41;
        Tue, 12 Jul 2022 17:54:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id e16so8884001pfm.11;
        Tue, 12 Jul 2022 17:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QlwkRFD6mAdlgOvFouE6L05mCIMY67NOdCG9WqjmiRI=;
        b=a9VFR75MoLuIb0fs16XAttUL0mBS+AbPHQjI7aCau5w82qLzOwiw9I7S+QCPaBHC7N
         42iZLYcJkVmkWY8KRKy3yu4s46KFPmbCv+3wdpZwTxdvPxuWRlfjZQ4Osne+esXG4QRY
         KJY7kdyKJhQzCqhZn5XtlcdbeEqHEuxwJBJezZyCTynKADTzYbjpxpiMZxSY3CYhvhFJ
         925uNm7ADAIBDZGSCDUxXLt49oMvi9ZUpUu0jfRjJdUzzyrXr+T2g1zqg2U94g6xrUp1
         8TViv1Gp0kR84wAa50xS2mBm/eD30b2L4DrgOQhl6wTXz2KLFyCHuPth5vLqedmCivF1
         YWsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QlwkRFD6mAdlgOvFouE6L05mCIMY67NOdCG9WqjmiRI=;
        b=3gkawG6gNw1bkTIHUAZ7xkoPdl/vCU1EOTsr7cK3GdKGGVpsbM2gphlayl7Ax0V/xz
         VppRX3wSWXM6fGzuaDM2G1KXcpe9bDCcSnw/hShrRpagNbUG15zva/BvbIAdyB3zxquR
         Oq2mKbORQO5gIVB/63zdu1NCJJRURAYKX0I6C1DZgJ6segBGq2Q8UIFq3wQ0xDHIpik7
         dKMvTdcFiwY4qPkFCXKFB82oAdYdyEV/uXK8a1mxki03ROH7SauFZIcMcEDK8cVpbuc9
         WN/6hC10OjAvdUHoz+FTUgZXnfqCtmH5o3cXV/6+0pgsrEe3vAMBIux17Y2hGR86H8qs
         9vyg==
X-Gm-Message-State: AJIora/8Ey5uQKT1bVWY19wKPLtWnaGNcViJds4pbI0eUFLlQqWKO414
        kuqHCmnIx3TjQqQpyXrr90w=
X-Google-Smtp-Source: AGRyM1tU9ZadfzoNoBuxavTh8ceN+n6p4mTlBwvKcOCRWWAI6SG0FBSr9E2bXvyBaP20W1UiJ4Sv+A==
X-Received: by 2002:a05:6a00:134e:b0:52a:d5b4:19bb with SMTP id k14-20020a056a00134e00b0052ad5b419bbmr610179pfu.45.1657673640951;
        Tue, 12 Jul 2022 17:54:00 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::5:580c])
        by smtp.gmail.com with ESMTPSA id 80-20020a621653000000b0052890d61628sm7401726pfw.60.2022.07.12.17.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 17:54:00 -0700 (PDT)
Date:   Tue, 12 Jul 2022 17:53:57 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, dhowells@redhat.com,
        jarkko@kernel.org, shuah@kernel.org, bpf@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/7] bpf: Add bpf_verify_pkcs7_signature() helper
Message-ID: <20220713005357.z74s36yet3veysno@macbook-pro-3.dhcp.thefacebook.com>
References: <20220712184128.999301-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712184128.999301-1-roberto.sassu@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 08:41:21PM +0200, Roberto Sassu wrote:
> One of the desirable features in security is the ability to restrict import
> of data to a given system based on data authenticity. If data import can be
> restricted, it would be possible to enforce a system-wide policy based on
> the signing keys the system owner trusts.
> 
> This feature is widely used in the kernel. For example, if the restriction
> is enabled, kernel modules can be plugged in only if they are signed with a
> key whose public part is in the primary or secondary keyring.
> 
> For eBPF, it can be useful as well. For example, it might be useful to
> authenticate data an eBPF program makes security decisions on.
> 
> After a discussion in the eBPF mailing list, it was decided that the stated
> goal should be accomplished by introducing a new helper:
> bpf_verify_pkcs7_signature(), dedicated to verify PKCS#7 signatures.
> 
> Other than the data and the signature, the helper also receives two
> parameters for the keyring, which can be provided as alternatives: one is a
> key pointer returned by the new bpf_lookup_user_key() helper, called with a
> key serial possibly decided by the user; another is a pre-determined ID
> among values defined in include/linux/verification.h.
> 
> While the first keyring-related parameter provides great flexibility, it
> seems suboptimal in terms of security guarantees, as even if the eBPF
> program is assumed to be trusted, the serial used to obtain the key pointer
> might come from untrusted user space not choosing one that the system
> administrator approves to enforce a mandatory policy.
> 
> The second keyring-related parameter instead provides much stronger
> guarantees, especially if the pre-determined ID is not passed by user space
> but is hardcoded in the eBPF program, and that program is signed. In this
> case, bpf_verify_pkcs7_signature() will always perform signature
> verification with a key that the system administrator approves, i.e. the
> primary, secondary or platform keyring.
> 
> bpf_lookup_user_key() comes with the corresponding release helper
> bpf_key_put(), to decrement the reference count of the key found with the
> former helper. The eBPF verifier has been enhanced to ensure that the
> release helper is always called whenever the acquire helper is called, or
> otherwise refuses to load the program.
> 
> bpf_lookup_user_key() also accepts lookup-specific flags KEY_LOOKUP_CREATE
> and KEY_LOOKUP_PARTIAL. Although these are most likely not useful for the
> bpf_verify_pkcs7_signature(), newly defined flags could be.
> 
> bpf_lookup_user_key() does not request a particular permission to
> lookup_user_key(), as it cannot determine it by itself. Also, it should not
> get it from the user, as the user could pass an arbitrary value and use the
> key for a different purpose. Instead, bpf_lookup_user_key() requests
> KEY_DEFER_PERM_CHECK, and defers the permission check to the helper that
> actually uses the key, in this patch set to bpf_verify_pkcs7_signature().
> 
> Since key_task_permission() is called by the PKCS#7 code during signature
> verification, the only additional function bpf_verify_pkcs7_signature() has
> to call is key_validate(). With that, the permission check can be
> considered complete and equivalent, as it was done by bpf_lookup_user_key()
> with the appropriate permission (in this case KEY_NEED_SEARCH).
> 
> All helpers can be called only from sleepable programs, because of memory
> allocation (with lookup flag KEY_LOOKUP_CREATE) and crypto operations. For
> example, the lsm.s/bpf attach point is suitable,
> fexit/array_map_update_elem is not.
> 
> The correctness of implementation of the new helpers and of their usage is
> checked with the introduced tests.
> 
> The patch set is organized as follows.
> 
> Patch 1 exports bpf_dynptr_get_size(), to obtain the real size of data
> carried by a dynamic pointer. Patch 2 makes available for new eBPF helpers
> some key-related definitions. Patch 3 introduces the bpf_lookup_user_key()
> and bpf_key_put() helpers. Patch 4 introduces the
> bpf_verify_pkcs7_signature(). Finally, patches 5-7 introduce the tests.
> 
> Changelog
> 
> v6:
>  - Switch back to key lookup helpers + signature verification (until v5),
>    and defer permission check from bpf_lookup_user_key() to
>    bpf_verify_pkcs7_signature()
>  - Add additional key lookup test to illustrate the usage of the
>    KEY_LOOKUP_CREATE flag and validate the flags (suggested by Daniel)
>  - Make description of flags of bpf_lookup_user_key() more user-friendly
>    (suggested by Daniel)
>  - Fix validation of flags parameter in bpf_lookup_user_key() (reported by
>    Daniel)
>  - Rename bpf_verify_pkcs7_signature() keyring-related parameters to
>    user_keyring and system_keyring to make their purpose more clear
>  - Accept keyring-related parameters of bpf_verify_pkcs7_signature() as
>    alternatives (suggested by KP)
>  - Replace unsigned long type with u64 in helper declaration (suggested by
>    Daniel)
>  - Extend the bpf_verify_pkcs7_signature() test by calling the helper
>    without data, by ensuring that the helper enforces the keyring-related
>    parameters as alternatives, by ensuring that the helper rejects
>    inaccessible and expired keyrings, and by checking all system keyrings
>  - Move bpf_lookup_user_key() and bpf_key_put() usage tests to
>    ref_tracking.c (suggested by John)
>  - Call bpf_lookup_user_key() and bpf_key_put() only in sleepable programs

Judging by amount of back and forth in api design and still outstanding
questions whether it's something that will work long term we probably
should not be baking these helpers into uapi.
Let's extend verifier support for ARG_PTR_TO_DYNPTR in kfunc and make
them all as kfuncs.
This way we can change them later.
