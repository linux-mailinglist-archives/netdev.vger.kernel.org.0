Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493856C3FE9
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 02:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCVBjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 21:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjCVBjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 21:39:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067262FCC1
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 18:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679449093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Aytx4qU5wRmsf/N1/l3pI2oz3cUuP+qLj3Iwt+/y300=;
        b=FRKr27Y9hNatSBluA9vysdrjbv/nMUZcJgsd8zS9LaOHoB5o4cwZE0IULdNvP9vIJKJg9P
        dVk3kh0kqj6JpgIhxVyMEswbJv0m03kRcAjJdpMLYaOTgrDC8d02zCcvmHl8PSHtnqIMKj
        MU+c4WcCd66qjQdqc7q2uupzUH2s8B0=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-1zBnaJC0M4CMXW8Svjk_Yg-1; Tue, 21 Mar 2023 21:38:11 -0400
X-MC-Unique: 1zBnaJC0M4CMXW8Svjk_Yg-1
Received: by mail-pj1-f71.google.com with SMTP id ml17-20020a17090b361100b0023f9e99ab95so3522597pjb.1
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 18:38:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679449091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aytx4qU5wRmsf/N1/l3pI2oz3cUuP+qLj3Iwt+/y300=;
        b=njs+h9vmy13NRU4wwHKBgQe9M1ix8uEVA4nTFhIvvnWwcgyvOBpEegtzxgx7D/aSBl
         FHpq3ldCUBZoxYWAsDNVvdG0addOl8TfWJ/W5hQS9g9twWFkyuH7XnjZwKAzrN/FBmzy
         2KZ/QhxGbTntBaKYR7jxn5xNQez0uBDY4l82yuDA7L/Cs82NSFZ8eIYoS/imKKI0Tbmu
         +9dFJr2dvhOzCgJOgGfZPb2rc6XOojmAR7OvirDV2nWMGqlUOuuQ2Zq1pFnlKtJ8Fej3
         fQMjwi1fFjtOjqmA+/JYRSmXSqXF+f84E01yIA9Q5qupPPZRdqqv0uHIflJWBJl3qA+M
         o8Ew==
X-Gm-Message-State: AO0yUKVGRrxkw8y3/7Mzbuo/Q/W/vXxl0EqEIL3arINt7rSI+AZclNGD
        lCxuPEz/kat+ZJkv264TwPzMHaOvxcFSn7Mn3i0Ij+/h8cZ1unX5wiTZTeNAokk1MaaCrkP0nj2
        yigRpxJQcuCVUMbY=
X-Received: by 2002:a05:6a20:b214:b0:d9:43a5:8cd0 with SMTP id eh20-20020a056a20b21400b000d943a58cd0mr3494354pzb.14.1679449090824;
        Tue, 21 Mar 2023 18:38:10 -0700 (PDT)
X-Google-Smtp-Source: AK7set/CzsCWsVX/TJsOfDDHjCiw3u0ZV36S6lazXGrCzDwLqZbml3ST7ALU3LJaCHYd/+SUwbonTA==
X-Received: by 2002:a05:6a20:b214:b0:d9:43a5:8cd0 with SMTP id eh20-20020a056a20b21400b000d943a58cd0mr3494337pzb.14.1679449090484;
        Tue, 21 Mar 2023 18:38:10 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 24-20020aa79158000000b00593e84f2d08sm8842580pfi.52.2023.03.21.18.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 18:38:10 -0700 (PDT)
Date:   Wed, 22 Mar 2023 09:38:04 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v3] net/sched: act_api: use the correct TCA_ACT
 attributes in dump
Message-ID: <ZBpb/MwzAO6yGcv4@Laptop-X1>
References: <20230321223345.1369859-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321223345.1369859-1-pctammela@mojatatu.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 07:33:45PM -0300, Pedro Tammela wrote:
> 4 places in the act api code are using 'TCA_' definitions where they
> should be using 'TCA_ACT_', which is confusing for the reader, although
> functionally they are equivalent.
> 
> Cc: Hangbin Liu <haliu@redhat.com>
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---

Acked-by: Hangbin Liu <haliu@redhat.com>

