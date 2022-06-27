Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4D555C749
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238134AbiF0T1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236070AbiF0T1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:27:41 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8F525E3
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:27:40 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id i17so16261621qvo.13
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jWN9KkoldwBL8Rqrz+i4lmpoezJgsLFsiXOd79nuhyY=;
        b=Rhs1cbt5Tx/+g43SRFbvdMexpOIUFeuhWt8HMCZ/BtsWLLtnMWEjCMmv8PQ2yhJeDo
         pEHi6caM7lpNPvU81kNBkJaa/JpR4+z4pSdtWfKqMaiFcpRZ/k9fVKaaWkk/ouT4SJwF
         KMp2yJZIfHsvN4itMeB2Qip7AjLWR7BSLpP0GfvdwQuzQkw9YE6qZYHxmo72F+YepFOx
         UgNwZf9BTqSv6t6N8dxFu2XmsUzWlZeNuVPsZBLbe5UlfUIq6cGshbu0iRTKB0aVo3hS
         wDVnjUOD5Lcj6Lur8Quc+mp2gU6wL8KKw5HaNtYl+6yNDJb+kD6q9TWzVwzFz95CD2Cw
         3hWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jWN9KkoldwBL8Rqrz+i4lmpoezJgsLFsiXOd79nuhyY=;
        b=nFJGbX/uydjEG3dbrx4cCnEA5lxHhyjy/h3HbnydLKWKGkulcmKSVmwxBKMRvpN2qQ
         BcyENrjlDu2BbMu79KJjA6sSR5ynY29FDIHuB1/TeanaabDi9nl6Mr32JLp3bkz1x2sj
         kbdSr/c0G8Uc164Ea0faAowUrs9QLzw8fhK6J01p8RjU9AkM+OlFS1OrHSugxIzTC25j
         kaSCBBZT/PoTyt4+13B81nB6hxdeIJ7PmDgGiytFzsKV8xxjF4eMhRklSU8tB6thANYm
         6j2AiaZl2fnBTRyOF5jUBy0pOiWBcWCQN3UN1h98RGs6snyuoOOLEtfrcCcWaQ3JnO4l
         Jjdw==
X-Gm-Message-State: AJIora+tMuJXUx/U4L6hL2HOLhYlewouEuFB3ziMUfwjDIUBpTiBkqD9
        uXFF5DuWMuxGJdcieneW1Wc=
X-Google-Smtp-Source: AGRyM1smI6xUOCtr3goUeW/13lb0elwLbVR1fNh8eZmYGrag3BPK16uMt5OYUuORTZtBVfT6cqNOAQ==
X-Received: by 2002:a0c:f3d1:0:b0:470:5951:9618 with SMTP id f17-20020a0cf3d1000000b0047059519618mr818527qvm.115.1656358059443;
        Mon, 27 Jun 2022 12:27:39 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:a41f:1e43:3539:7330])
        by smtp.gmail.com with ESMTPSA id bw20-20020a05622a099400b00304bc2acc25sm7586125qtb.6.2022.06.27.12.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 12:27:39 -0700 (PDT)
Date:   Mon, 27 Jun 2022 12:27:37 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, quic_jzenner@quicinc.com,
        Cong Wang <cong.wang@bytedance.com>, qitao.xu@bytedance.com,
        Sean Tranchetti <quic_stranche@quicinc.com>
Subject: Re: [PATCH net-next] net: Print real skb addresses for all net events
Message-ID: <YroEqWGVD9jDzmTS@pop-os.localdomain>
References: <1656050956-9762-1-git-send-email-quic_subashab@quicinc.com>
 <CANn89iJ_HBEkiU3ToAjcv_KHz3f77DJpycKcU=74X3rNst-V6g@mail.gmail.com>
 <7ebc5299-fb49-d6d9-d54b-6a8835688ce4@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ebc5299-fb49-d6d9-d54b-6a8835688ce4@quicinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 02:48:24AM -0600, Subash Abhinov Kasiviswanathan (KS) wrote:
> 
> 
> On 6/24/2022 12:27 AM, Eric Dumazet wrote:
> > On Fri, Jun 24, 2022 at 8:09 AM Subash Abhinov Kasiviswanathan
> > <quic_subashab@quicinc.com> wrote:
> > > 
> > > Commit 65875073eddd ("net: use %px to print skb address in trace_netif_receive_skb")
> > > added support for printing the real addresses for the events using
> > > net_dev_template.
> > > 
> > 
> > It is not clear why the 'real address' is needed in trace events.
> > 
> > I would rather do the opposite.
> > 
> 
> We don't need the real address. We just need the events to display in the
> same format - hashed address is fine.
> 
> > diff --git a/include/trace/events/net.h b/include/trace/events/net.h
> > index 032b431b987b63b5fab1d3c763643d6192f2c325..da611a7aaf970f541949cdd87ac9203c4c7e81b1
> > 100644
> > --- a/include/trace/events/net.h
> > +++ b/include/trace/events/net.h
> > @@ -136,7 +136,7 @@ DECLARE_EVENT_CLASS(net_dev_template,
> >                  __assign_str(name, skb->dev->name);
> >          ),
> > 
> > -       TP_printk("dev=%s skbaddr=%px len=%u",
> > +       TP_printk("dev=%s skbaddr=%p len=%u",
> >                  __get_str(name), __entry->skbaddr, __entry->len)
> >   )
> > 
> 
> Qitao / Cong, do you have any concerns as it ends up reverting commit
> 65875073eddd ("net: use %px to print skb address in
> trace_netif_receive_skb")

Yes, see this example:
https://lists.openwall.net/netdev/2021/07/28/24

Thanks.
