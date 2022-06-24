Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A8B5595BA
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 10:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiFXIs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 04:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiFXIs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 04:48:28 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEB655349
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 01:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1656060507; x=1687596507;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s1D2Wdz+fC9PPZHt6sjjaqmaODYlyFYA4lyFzkrPfL4=;
  b=I/N49fUwO2QSBRTi+Md5sPH5Ughyy5ppPVEnPhJ8SltIhlpTcQwmv6eO
   QvLGpFgUvIb4o+F2Y8OzE67FNO+FI1ZfExtiLBYsdcewqFilYHoOg/O3Z
   nr8byV57/AIFTEc3nm30wWIkYNfN/U/0r0+lwj0h1oxxoo2T8DTkS+Y2i
   I=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 24 Jun 2022 01:48:27 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 01:48:27 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 24 Jun 2022 01:48:26 -0700
Received: from [10.110.103.155] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 24 Jun
 2022 01:48:25 -0700
Message-ID: <7ebc5299-fb49-d6d9-d54b-6a8835688ce4@quicinc.com>
Date:   Fri, 24 Jun 2022 02:48:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next] net: Print real skb addresses for all net events
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, <quic_jzenner@quicinc.com>,
        Cong Wang <cong.wang@bytedance.com>, <qitao.xu@bytedance.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
References: <1656050956-9762-1-git-send-email-quic_subashab@quicinc.com>
 <CANn89iJ_HBEkiU3ToAjcv_KHz3f77DJpycKcU=74X3rNst-V6g@mail.gmail.com>
From:   "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
In-Reply-To: <CANn89iJ_HBEkiU3ToAjcv_KHz3f77DJpycKcU=74X3rNst-V6g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2022 12:27 AM, Eric Dumazet wrote:
> On Fri, Jun 24, 2022 at 8:09 AM Subash Abhinov Kasiviswanathan
> <quic_subashab@quicinc.com> wrote:
>>
>> Commit 65875073eddd ("net: use %px to print skb address in trace_netif_receive_skb")
>> added support for printing the real addresses for the events using
>> net_dev_template.
>>
> 
> It is not clear why the 'real address' is needed in trace events.
> 
> I would rather do the opposite.
> 

We don't need the real address. We just need the events to display in 
the same format - hashed address is fine.

> diff --git a/include/trace/events/net.h b/include/trace/events/net.h
> index 032b431b987b63b5fab1d3c763643d6192f2c325..da611a7aaf970f541949cdd87ac9203c4c7e81b1
> 100644
> --- a/include/trace/events/net.h
> +++ b/include/trace/events/net.h
> @@ -136,7 +136,7 @@ DECLARE_EVENT_CLASS(net_dev_template,
>                  __assign_str(name, skb->dev->name);
>          ),
> 
> -       TP_printk("dev=%s skbaddr=%px len=%u",
> +       TP_printk("dev=%s skbaddr=%p len=%u",
>                  __get_str(name), __entry->skbaddr, __entry->len)
>   )
> 

Qitao / Cong, do you have any concerns as it ends up reverting commit 
65875073eddd ("net: use %px to print skb address in 
trace_netif_receive_skb")

> diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
> index 59c945b66f9c7469bc071e2a27efb8bfa9eb19f7..a3995925cb057021dc779344d19f7e3724f6df3c
> 100644
> --- a/include/trace/events/qdisc.h
> +++ b/include/trace/events/qdisc.h
> @@ -41,7 +41,7 @@ TRACE_EVENT(qdisc_dequeue,
>                  __entry->txq_state      = txq->state;
>          ),
> 
> -       TP_printk("dequeue ifindex=%d qdisc handle=0x%X parent=0x%X
> txq_state=0x%lX packets=%d skbaddr=%px",
> +       TP_printk("dequeue ifindex=%d qdisc handle=0x%X parent=0x%X
> txq_state=0x%lX packets=%d skbaddr=%p",
>                    __entry->ifindex, __entry->handle, __entry->parent,
>                    __entry->txq_state, __entry->packets, __entry->skbaddr )
>   );
> @@ -70,7 +70,7 @@ TRACE_EVENT(qdisc_enqueue,
>                  __entry->parent  = qdisc->parent;
>          ),
> 
> -       TP_printk("enqueue ifindex=%d qdisc handle=0x%X parent=0x%X
> skbaddr=%px",
> +       TP_printk("enqueue ifindex=%d qdisc handle=0x%X parent=0x%X skbaddr=%p",
>                    __entry->ifindex, __entry->handle, __entry->parent,
> __entry->skbaddr)
>   );
> 
> 
