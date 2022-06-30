Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AE15616FF
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbiF3J7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 05:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbiF3J7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 05:59:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FECC43EDC
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 02:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656583187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NC+H5hXtiaJInznME5rdufUAlp/Za1C8dNUJeDIUNOg=;
        b=epWERT6KggTxHj8n9gcj07Rg2HIKxud80MwE5UgDAldgo2WvURh3PrBRWdKfSQPcEc3WZM
        ashjSwuaSw2iOeClwuHaKFti3rX1tOzlOn7EshwPKhEed4Uk3Y4CMgE/ww6A9TyZhipon7
        676fgjC9E7VEWXT0F1u1RM4YrlAjShU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-a5perYSGNsK7hxAZ25Ma5Q-1; Thu, 30 Jun 2022 05:59:46 -0400
X-MC-Unique: a5perYSGNsK7hxAZ25Ma5Q-1
Received: by mail-ed1-f72.google.com with SMTP id w8-20020a056402268800b004379267f163so9091970edd.20
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 02:59:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=NC+H5hXtiaJInznME5rdufUAlp/Za1C8dNUJeDIUNOg=;
        b=Pe/h1Dy2HLiM7EidHww0g1IQ4nO0VgRpQQpE0OXTd1m/3KVeZgIXo2e3nUKCmHvrd2
         S2M5giw0AFmCoV2CmH6s+DjoHXIfkrvyED4p0KqWV1h8VwgGXKeEDPpL4DrCxa3FMymJ
         mzf++CEBRnM7WjPykEh7dnZPbQS2vfSStUpznGSmaFIOzjhzWy1KRj0ykcE01/fKsbq1
         KvMX1r0N9U1Jrt6DLxan9wcJdsZTBat3c756VmeafLhip4Nyg6u0mq5q5tiZO9iKAHEG
         7Jx1yLN4WpbzWs8d0gJMNQJrx3pwLFmuvNN+H0BpwmyYbxwVwrTKbdXUiJHyXBfjSioL
         ukFw==
X-Gm-Message-State: AJIora/XhwqjCyMqCvOEJkuDqqd0I6MSBezE7M5wueSDdyhrbsdHD2cI
        Ahbj/EP5gKE7Vr4zZt6hYW0+jO9UIcPZkjM9DiVMptcG2qJfH1zhdEEiEhVg/KYq1WzwZAjD4fz
        VHC1sDCh2reFwpweM
X-Received: by 2002:a17:907:2081:b0:726:b8d2:fba2 with SMTP id pv1-20020a170907208100b00726b8d2fba2mr7639401ejb.686.1656583184938;
        Thu, 30 Jun 2022 02:59:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t1S1W25dURd15AZ3MztnXY3TSRgSRNqUgYkbdGb+99PRZXdzvLzph1VYG0fY9Luzlj0hC3uw==
X-Received: by 2002:a17:907:2081:b0:726:b8d2:fba2 with SMTP id pv1-20020a170907208100b00726b8d2fba2mr7639372ejb.686.1656583184539;
        Thu, 30 Jun 2022 02:59:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c1-20020a056402158100b004357dca07cdsm13029565edv.88.2022.06.30.02.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 02:59:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1468F4771FA; Thu, 30 Jun 2022 11:59:43 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        andrii@kernel.org, hawk@kernel.org
Cc:     bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] selftests, bpf: remove AF_XDP samples
In-Reply-To: <20220630093717.8664-1-magnus.karlsson@gmail.com>
References: <20220630093717.8664-1-magnus.karlsson@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 30 Jun 2022 11:59:43 +0200
Message-ID: <877d4ya2uo.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson <magnus.karlsson@gmail.com> writes:

> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Remove the AF_XDP samples from samples/bpf as they are dependent on
> the AF_XDP support in libbpf. This support has now been removed in the
> 1.0 release, so these samples cannot be compiled anymore. Please start
> to use libxdp instead. It is backwards compatible with the AF_XDP
> support that was offered in libbpf. New samples can be found in the
> various xdp-project repositories connected to libxdp and by googling.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

