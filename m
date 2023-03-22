Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D058F6C45B3
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 10:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjCVJIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 05:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCVJHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 05:07:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94985D899
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679476006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2MlHDqfGbslAe9msaTatiN+17p55n60LjBLi0mnLeSo=;
        b=BwQ0BHuW+1+7MP0LJhUJdQJJo9gE3kJriH1Y9Rww3Q9c6eowiCEw61wPpRm9TC+S4EVEmN
        Q4RUIraGwfCilnfnxmkfmNZSpW/e8bdDjoehs+/v0mpP728U6JhrIHFsnwobpXcBfU4XJ3
        IJSFXDQmAKxH5NmHt2cy3p5oODbBsBE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-4r5Bt2UAPfayEdo_5pujEg-1; Wed, 22 Mar 2023 05:06:43 -0400
X-MC-Unique: 4r5Bt2UAPfayEdo_5pujEg-1
Received: by mail-qv1-f71.google.com with SMTP id px9-20020a056214050900b005d510cdfc41so1704879qvb.7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:06:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679476003;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2MlHDqfGbslAe9msaTatiN+17p55n60LjBLi0mnLeSo=;
        b=ZI47YJUZ6V6AKAJHDQr6+FuOoq0xC6icCKhOiOxiqKWDen0SjgPx4oZ6Sh54tpe0e7
         DGtiYAYub5JQ9Y+UXQtwNUksSHru/KFdcSCfm9lgImkUIAirZxN3JLuWRGaXKmY4VrrB
         6bABTVeh+bgjZvvd5HNPFQLYJ8LabeFXm0gwH0X3ARwJ9xWT0+d+x3VV+6869PA2wzaV
         a+okc4KYn2WkRPQdyiopNbfV1Y2eARMa/7R3KmqOWbBlMA3QFKg3mF4sicWCFdW6V13P
         1la7/bdLrTMNrHlQWBWE94BdI4y+4yyZnyGDCoxDRZaXHhyjCEE/CapzR3LGVn/BVFMQ
         mgTA==
X-Gm-Message-State: AO0yUKW7WhEZdh0dptxWDte6JbTx4Br7iwSojrXOJrqwV8aexcK3OFwO
        yjwTmX18FYvu0bUbcVBmp00navceXA/q4Sxg5mhA/f4GzbTiNgZqbBClxoVJRpCh4JHzSJuixB1
        9cF0pmJqRzSeqrZum
X-Received: by 2002:a05:6214:5093:b0:5a9:ab44:5fdf with SMTP id kk19-20020a056214509300b005a9ab445fdfmr8701210qvb.0.1679476003332;
        Wed, 22 Mar 2023 02:06:43 -0700 (PDT)
X-Google-Smtp-Source: AK7set+3Db3BEp45bS/UBFNKv/x87AWA9BOyr2ex9r1mT8G7M4NEeoWmDR67cxCj76ccwFZdVl3P2g==
X-Received: by 2002:a05:6214:5093:b0:5a9:ab44:5fdf with SMTP id kk19-20020a056214509300b005a9ab445fdfmr8701185qvb.0.1679476003041;
        Wed, 22 Mar 2023 02:06:43 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-168.dyn.eolo.it. [146.241.244.168])
        by smtp.gmail.com with ESMTPSA id u23-20020a37ab17000000b0071f0d0aaef7sm7581331qke.80.2023.03.22.02.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 02:06:42 -0700 (PDT)
Message-ID: <b2ef2852d49ffa443c1f56ab78c5872afa5e9ef8.camel@redhat.com>
Subject: Re: [PATCH v7 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
From:   Paolo Abeni <pabeni@redhat.com>
To:     Chuck Lever <cel@kernel.org>, kuba@kernel.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
Date:   Wed, 22 Mar 2023 10:06:40 +0100
In-Reply-To: <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
References: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
         <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

   On Sat, 2023-03-18 at 12:18 -0400, Chuck Lever wrote:
> static bool __add_pending_locked(struct handshake_net *hn,
> +				 struct handshake_req *req)
> +{
> +	if (!list_empty(&req->hr_list))
> +		return false;

I think the above condition should be matched only an bugs/API misuse,
am I correct? what about adding a WARN_ON_ONCE()?

Thanks!

Paolo

