Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463304CB231
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 23:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245279AbiCBWVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 17:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245427AbiCBWVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 17:21:45 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5A5D64C7;
        Wed,  2 Mar 2022 14:21:00 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id p17so2801272plo.9;
        Wed, 02 Mar 2022 14:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7nNxLa5fVLf7zBJyhXcOqLR/oQ9otRapOrLZOBmy+fs=;
        b=Yx2Tu1pyRlHwyWfAJpaPEYBK7U9Xa99I7npuIMQDOm1nT+bKEWdz9xuk9vvQiYr6J8
         m1U1geFt2wL4cHfRXI9KOdoZNY51YM8PgOUStDGYaT8EXuRMtYZw20kOBukG/tLik6lf
         I0+G0WYqOLGTVWbD+OP460WGiCHhUe2jIN76eywXx51y/KwDNyJGRD4pp7pwjc/wJiaI
         vVbW1C767aYo5MU1Swv6OSimECLQ2Z0f+iBvSA6zIGTnAxQxOcDShEQS1e4HdBUH4EDX
         r9S5UNIPWTXY9ud/6RiFoDm39kjo7s8VJhjQxeP4QymVnd8IOBYOvCBQHc3pIKgFQZBN
         uf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7nNxLa5fVLf7zBJyhXcOqLR/oQ9otRapOrLZOBmy+fs=;
        b=Iq2JiWqmC/iD+Xk6YKx9kpodTGpfEQTgSi4IhwVkW+R0jdM+nxS8GnLu6LUSZyCo7p
         jQoJDwBLoLmpddyimWTJWveVVgQS/h6DG5QJPHpZNQsJpedW+Xol2g0NRFmX36My3tTy
         rxBEb/BpWuBi+2GOlYwz5xCmBxPUdF41qWFES8y170ZQxQ6Ho0gXfYvPkNCcCU3A8mQB
         jBMXTr3llKq5CZicr0upJhgbo7PCBNm9taa6JaVwLwwujVDgxzOouzSXCmh6pgTrMJNG
         Hew3rzKRAamBfV4VZl2JPfsmwmuhZG7bIgotVXEr4c7OvXSgqPOpLF14xfiw9ESZ0qGA
         K+Vw==
X-Gm-Message-State: AOAM533av3EAY7GNKuCJEI/t5BXJWFGs+IQyQMRnXVkiAQYo2NEZhVCf
        zdSyeNM3gwENdnLJeGYkjFk=
X-Google-Smtp-Source: ABdhPJw3LwqNN9faD/CN8tV5gcaPOEskQM2Wni+pDcj4Vlrbq+CBge0QXPo1hghH4Dd+dIkl+666fQ==
X-Received: by 2002:a17:902:7786:b0:14d:51c6:21a8 with SMTP id o6-20020a170902778600b0014d51c621a8mr33480455pll.75.1646259659674;
        Wed, 02 Mar 2022 14:20:59 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:500::2:156b])
        by smtp.gmail.com with ESMTPSA id h6-20020a636c06000000b00363a2533b17sm151118pgc.8.2022.03.02.14.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 14:20:59 -0800 (PST)
Date:   Wed, 2 Mar 2022 14:20:56 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     zohar@linux.ibm.com, shuah@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, revest@chromium.org,
        gregkh@linuxfoundation.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
Message-ID: <20220302222056.73dzw5lnapvfurxg@ast-mbp.dhcp.thefacebook.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302111404.193900-1-roberto.sassu@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 12:13:55PM +0100, Roberto Sassu wrote:
> Extend the interoperability with IMA, to give wider flexibility for the
> implementation of integrity-focused LSMs based on eBPF.
> 
> Patch 1 fixes some style issues.
> 
> Patches 2-6 give the ability to eBPF-based LSMs to take advantage of the
> measurement capability of IMA without needing to setup a policy in IMA
> (those LSMs might implement the policy capability themselves).
> 
> Patches 7-9 allow eBPF-based LSMs to evaluate files read by the kernel.
> 
> Changelog
> 
> v2:
> - Add better description to patch 1 (suggested by Shuah)
> - Recalculate digest if it is not fresh (when IMA_COLLECTED flag not set)
> - Move declaration of bpf_ima_file_hash() at the end (suggested by
>   Yonghong)
> - Add tests to check if the digest has been recalculated
> - Add deny test for bpf_kernel_read_file()
> - Add description to tests
> 
> v1:
> - Modify ima_file_hash() only and allow the usage of the function with the
>   modified behavior by eBPF-based LSMs through the new function
>   bpf_ima_file_hash() (suggested by Mimi)
> - Make bpf_lsm_kernel_read_file() sleepable so that bpf_ima_inode_hash()
>   and bpf_ima_file_hash() can be called inside the implementation of
>   eBPF-based LSMs for this hook
> 
> Roberto Sassu (9):
>   ima: Fix documentation-related warnings in ima_main.c
>   ima: Always return a file measurement in ima_file_hash()
>   bpf-lsm: Introduce new helper bpf_ima_file_hash()
>   selftests/bpf: Move sample generation code to ima_test_common()
>   selftests/bpf: Add test for bpf_ima_file_hash()
>   selftests/bpf: Check if the digest is refreshed after a file write
>   bpf-lsm: Make bpf_lsm_kernel_read_file() as sleepable
>   selftests/bpf: Add test for bpf_lsm_kernel_read_file()
>   selftests/bpf: Check that bpf_kernel_read_file() denies reading IMA
>     policy

We have to land this set through bpf-next.
Please get the Acks for patches 1 and 2, so we can proceed.
