Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4F66361C6
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238732AbiKWO3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiKWO3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:29:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F006085159
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669213625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ci/dFCNljVcFf9q9RRytIXDpm4lKFdZkNw15CAnsDvQ=;
        b=Tunx1bZlGPiWZnDv9dddIoLxGbqMKUSwa51WgX282QTl6V6yem1howw3vPre/2Mqp+Xeaf
        1Wi2l7wR5flX8mO4uIvSbceA5OkrCGmMpw5pRq9IjwFgJ28UZfQWs1WJwEKBZKFTEGPyqn
        2uKfPiqCOH0a7JlHWK5Iq6lMa4Fmue0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-474-gSEUbMFYPRurtm7T6I_Ivw-1; Wed, 23 Nov 2022 09:26:53 -0500
X-MC-Unique: gSEUbMFYPRurtm7T6I_Ivw-1
Received: by mail-ej1-f70.google.com with SMTP id qa14-20020a170907868e00b007ae24f77742so9980126ejc.8
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:26:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ci/dFCNljVcFf9q9RRytIXDpm4lKFdZkNw15CAnsDvQ=;
        b=4dNwlNfPupF7lhXHwT4e/LPiWwBkzp+goYBCC/P3pVNHVHnkiF0qsGmjCxFEoiI/X1
         VAFvJ+Ymdglqu261Ab0bBrn3iPVFbqNg5cTa5CXj2wBOKfYRq0mv97zNFnVXSppF2ImN
         CLAV5dvVA2vsGv/aUUvVGiDP2gdo+5flPrxocMG8ZzA1pPScdjcwLCAN3tpuKM7eTeNb
         zRk5ooD75H4tk7xzFJ3ckbq9EsDMnDfQH3lK5UR3MJ6t0CIpCxXHzmSoB40GwZPqWEkc
         m/3fy3iQmuiWFdzue5ko4OxXXOSnM0hcJuopoUHfrVrR2uYLr0PCixYJYZcaLjaRH1bG
         QtTQ==
X-Gm-Message-State: ANoB5pmrxWmQAXewwo5/S3pH8FCEvPW4PcpmIMV3dnjL7YA970h+DCgK
        H/yPVL6xjAo7mZtHKKkFp/deRzWWNRVKEubOxO2Io6+SBsLfUOuW/YZUc4KGHabccTeWn/c4dfj
        PDJB61w9CRxvgEnyq
X-Received: by 2002:a17:906:81c4:b0:78d:9858:e538 with SMTP id e4-20020a17090681c400b0078d9858e538mr24440813ejx.502.1669213611722;
        Wed, 23 Nov 2022 06:26:51 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4KqxmrmIDbHgSTSQNejPu/z2+DPqzYorDZmwBIJ8vMgCMYGubMeimvSckzbonP+MTiW7z8xA==
X-Received: by 2002:a17:906:81c4:b0:78d:9858:e538 with SMTP id e4-20020a17090681c400b0078d9858e538mr24440776ejx.502.1669213611315;
        Wed, 23 Nov 2022 06:26:51 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id kw1-20020a170907770100b0078246b1360fsm7283131ejc.131.2022.11.23.06.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 06:26:50 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 274AF7D5116; Wed, 23 Nov 2022 15:26:50 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] [PATCH bpf-next v2 8/8] selftests/bpf: Simple
 program to dump XDP RX metadata
In-Reply-To: <20221121182552.2152891-9-sdf@google.com>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-9-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 23 Nov 2022 15:26:50 +0100
Message-ID: <877czlvj9x.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> +static int rxq_num(const char *ifname)
> +{
> +	struct ethtool_channels ch = {
> +		.cmd = ETHTOOL_GCHANNELS,
> +	};
> +
> +	struct ifreq ifr = {
> +		.ifr_data = (void *)&ch,
> +	};
> +	strcpy(ifr.ifr_name, ifname);
> +	int fd, ret;
> +
> +	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
> +	if (fd < 0)
> +		error(-1, errno, "socket");
> +
> +	ret = ioctl(fd, SIOCETHTOOL, &ifr);
> +	if (ret < 0)
> +		error(-1, errno, "socket");
> +
> +	close(fd);
> +
> +	return ch.rx_count;
> +}

mlx5 uses 'combined' channels, so this returns 0. Changing it to just:

return ch.rx_count ?: ch.combined_count; 

works though :)

-Toke

