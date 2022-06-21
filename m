Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CE7553E8E
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 00:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354394AbiFUWcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 18:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354293AbiFUWcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 18:32:53 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3319FB10;
        Tue, 21 Jun 2022 15:32:52 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id l4so14364737pgh.13;
        Tue, 21 Jun 2022 15:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bCGwgJ54k50n6/C1tzTJMCUpqkUbQt+F2+DBinDbYdI=;
        b=OpRVa0P6HpxO9cV5yYoxShuNhHfkQnBelqtCvQUglsgsmUf1xikiAeMNU+fw512OTc
         KlUun+wU6gB6mWfg0vvZpcyct10Z8BWEEJgOpV4aVGzJse4NZpHIe+tUPKWwNDOxbjpD
         RbWgo8RIgXzl59PDH8RVOC/udaSOwueM2p+ctIGsA3Q1uWt+OWcpoJPcKs0nfg5XwuCX
         t5AzPPMMK/hrs2FMI7xkyAj6jBP+lDd9fPFmjC0vH71Q5VC9Buvu2OvxEHaKqBvuDp8r
         V1ZjO3sAoWluJoMlFIFQrx/1rz+4nKeIxQ+xHAmf9kGPcOQS3tNM0QfNACb6EsewS2aI
         98KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bCGwgJ54k50n6/C1tzTJMCUpqkUbQt+F2+DBinDbYdI=;
        b=Gmd1SITRL+trvUtIWaPPE+6V6TFHvJmgY5oMMcrqSNHS5jX7mwuco3mSTP/LjasNL3
         nnrGwZUxS4CHq4exEPce0cnUlSdHXIjPcBSp1BqaoDRsrWbpPIS8GnT8+ITrf7z8q3Na
         so757lkW+GASeauoVti5a2JCvJx1PVLLaadd73LflO51YzQndoKTe/81g3K3JOKpnKqL
         a4MWyyEtGOg+jeU5wFDp8NJDk7nlAQTx5PlI0j3t8wEQX0yTCMmAJG7Z390smXbvl7t2
         xQ5EnL1XgX3S968FU2s5XZh1HInSw4GxF3v2ntTKE58que8TG4J2yw5cVH163MYKv9uB
         xb2w==
X-Gm-Message-State: AJIora8J2rwGtaFZ9hE4ivCY6sd6TzA1zAMfa39QWqvHzgGspj65MAGk
        i9AnGuTGE7c7PPUAHKhLASI=
X-Google-Smtp-Source: AGRyM1sFiHp4QwjL+cqefg77XlGuOS/0kfTCNWEXlZGCxKLwnECC1kemPDp/INmZhAgwvtNXNXbvsQ==
X-Received: by 2002:a05:6a00:80a:b0:51c:7569:5af with SMTP id m10-20020a056a00080a00b0051c756905afmr32249587pfk.68.1655850771489;
        Tue, 21 Jun 2022 15:32:51 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::5:29cb])
        by smtp.gmail.com with ESMTPSA id a13-20020a1709027e4d00b0015e8d4eb26csm11250290pln.182.2022.06.21.15.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:32:51 -0700 (PDT)
Date:   Tue, 21 Jun 2022 15:32:48 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kpsingh@kernel.org, john.fastabend@gmail.com,
        songliubraving@fb.com, kafai@fb.com, yhs@fb.com,
        dhowells@redhat.com, keyrings@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/5] bpf: Add bpf_lookup_user_key() and bpf_key_put()
 helpers
Message-ID: <20220621223248.f6wgyewajw6x4lgr@macbook-pro-3.dhcp.thefacebook.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-3-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621163757.760304-3-roberto.sassu@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 06:37:54PM +0200, Roberto Sassu wrote:
> Add the bpf_lookup_user_key() and bpf_key_put() helpers, to respectively
> search a key with a given serial, and release the reference count of the
> found key.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  include/uapi/linux/bpf.h       | 16 ++++++++++++
>  kernel/bpf/bpf_lsm.c           | 46 ++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c          |  6 +++--
>  scripts/bpf_doc.py             |  2 ++
>  tools/include/uapi/linux/bpf.h | 16 ++++++++++++
>  5 files changed, 84 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index e81362891596..7bbcf2cd105d 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5325,6 +5325,20 @@ union bpf_attr {
>   *		**-EACCES** if the SYN cookie is not valid.
>   *
>   *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
> + *
> + * struct key *bpf_lookup_user_key(u32 serial, unsigned long flags)
> + *	Description
> + *		Search a key with a given *serial* and the provided *flags*, and
> + *		increment the reference count of the key.

Why passing 'flags' is ok to do?
Please think through every line of the patch.
