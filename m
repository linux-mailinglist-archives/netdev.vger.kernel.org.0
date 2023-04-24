Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666336ED1A9
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 17:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbjDXPqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 11:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjDXPqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 11:46:38 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F0AFF;
        Mon, 24 Apr 2023 08:46:37 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-94a34a14a54so839644566b.1;
        Mon, 24 Apr 2023 08:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682351196; x=1684943196;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V5kfApywC3Ow430wPUAgz5gf5mqhvM+JQLcnZKUUo1Y=;
        b=IXr+Fpca8MOCigDbW76uRXHkLmsQH79O1FnNrry/Ucde/hSZsMNI8IwKoKfOYABhq7
         na9U49hOK9Ann05rowzKO16PNnamn77Y3B1wTz334Z6ax6iPrvy15H/srgsPsMpxRFrc
         JN1hQdg3G2RP+ochAbZmp7o7YPa4sH+azbyukY4vcvpCBmyUhEGVHSCwWNjolAuWycmp
         w73X/QzKIa96QmKZcnFa9VKX5vd51xt1lXzlQB3AnUNhjIU9ABN3WEOPGnu+EI5fhZz7
         b/vtqmKcc6r6wI/4l0hWQn8cHrS60PHQmbutDgrv27FnDF8vUq8BQzoSDUJKh7qEK1dy
         YYpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682351196; x=1684943196;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V5kfApywC3Ow430wPUAgz5gf5mqhvM+JQLcnZKUUo1Y=;
        b=Lg5ZbWzXsSLJI5LIWDi+sfAC1LnYKhQv74pPerMqIUs7dEvT0QzG6gCErq09L9M9gw
         Nww0J0UknBGki9PO/OphBRnxcU7g4LrIkjvw6NaGqr8I5NzBemJBjPo+nuf3/gstM48F
         1qX4az1aBS5L8Utl9GS2fo5+8ADrEpUG0ykUjQOteeJhWxeU+1xjp7CzrZYuqvhLj6Tv
         wzXZCl0ojpvn1OKkEEX0MfwKDFO4OB6lF6PiW9Y3DkwPF/AW/s9Rb8+GM8Y95J5NgTct
         1UNM/zfLQ/gYNiSOSm5wC45Gm6QU+pOO28YZRiqIcyNPG44ucf4Y/Cg1ePXqNdCe8SGQ
         53Wg==
X-Gm-Message-State: AAQBX9cWhWjMBRSwV9Xeznm0pDdOzQDns1f3nSVBasg9BXAvrxe5IpuW
        Vng6rfIFGhAwAeQdUmRGqJc=
X-Google-Smtp-Source: AKy350Zuoz9PnUCU5TWWaKvoVdBPmG7sPAhJxw1mGmJ8GSCaL/no7YR9O2XJMd7/SFWczzJRZ7dGNA==
X-Received: by 2002:a17:906:9b45:b0:94e:5679:d950 with SMTP id ep5-20020a1709069b4500b0094e5679d950mr8526128ejc.72.1682351195882;
        Mon, 24 Apr 2023 08:46:35 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id lu14-20020a170906face00b0094f4e914f67sm5587915ejb.66.2023.04.24.08.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 08:46:35 -0700 (PDT)
Date:   Mon, 24 Apr 2023 16:46:32 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Gautam Dawar <gdawar@amd.com>, Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@amd.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-net-drivers@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v4 00/14] sfc: add vDPA support for EF100 devices
Message-ID: <ZEakWHUV3t+Q3DwV@gmail.com>
Mail-Followup-To: Leon Romanovsky <leon@kernel.org>,
        Gautam Dawar <gdawar@amd.com>, Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@amd.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-net-drivers@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230407081021.30952-1-gautam.dawar@amd.com>
 <20230409091325.GF14869@unreal>
 <CACGkMEur1xkFPxaiVVhnZqHzUdyyqw6a0vw=GHpYKJM7U3cj7Q@mail.gmail.com>
 <ba8c6139-66c3-a04b-143d-546f9cbccb70@amd.com>
 <20230410075333.GM182481@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230410075333.GM182481@unreal>
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 10:53:33AM +0300, Leon Romanovsky wrote:
> On Mon, Apr 10, 2023 at 12:03:25PM +0530, Gautam Dawar wrote:
> > 
> > On 4/10/23 07:09, Jason Wang wrote:
> > > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > > 
> > > 
> > > On Sun, Apr 9, 2023 at 5:13 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > On Fri, Apr 07, 2023 at 01:40:01PM +0530, Gautam Dawar wrote:
> > > > > Hi All,
> > > > > 
> > > > > This series adds the vdpa support for EF100 devices.
> > > > > For now, only a network class of vdpa device is supported and
> > > > > they can be created only on a VF. Each EF100 VF can have one
> > > > > of the three function personalities (EF100, vDPA & None) at
> > > > > any time with EF100 being the default. A VF's function personality
> > > > > is changed to vDPA while creating the vdpa device using vdpa tool.
> > > > Jakub,
> > > > 
> > > > I wonder if it is not different approach to something that other drivers
> > > > already do with devlink enable knobs (DEVLINK_PARAM_GENERIC_ID_ENABLE_*)
> > > > and auxiliary bus.
> > > I think the auxiliary bus fits here, and I've proposed to use that in
> > > V2 of this series.
> > 
> > Yeah, right and you mentioned that are fine with it if this is done sometime
> > in future to which Martin responded saying the auxbus approach will be
> > considered when re-designing sfc driver for the upcoming projects on the
> > roadmap.
> 
> Adding new subsystem access (vDPA) is the right time to move to auxbus.
> This is exactly why it was added to the kernel.
> 
> We asked to change drivers for Intel, Pensando, Mellanox and Broadcom
> and they did it. There are no reasons to do it differently for AMD.

We have obtained permission from our management to incorporate auxbus for this,
and will start work on a design for this.

Best regards,
Martin

> Thanks
> 
> > 
> > Gautam
> > 
> > > 
> > > Thanks
> > > 
> > > > Thanks
> > > > 
