Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61074C3E21
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 06:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbiBYF6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 00:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiBYF6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 00:58:13 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB3270CED;
        Thu, 24 Feb 2022 21:57:41 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id m13-20020a17090aab0d00b001bbe267d4d1so7066765pjq.0;
        Thu, 24 Feb 2022 21:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rhANxfNQ/ituVJr7EmvsE6S1nIqGh/dAoPOGlDajFpg=;
        b=gm10Ic/UODLwex0cfQchB973ESn47S707IXCtrZXmHq3gGwtQnE7FrTUcTccXRXIVG
         jf8duKO2G2gIxuGeuj0P844SPN/1oN8113lT5Yha78UyCcvVpRQz5IYjbOqkKBkEmMUY
         WcVkoqC5ygReWE88DxB4KsfYecE4dVA2oL9bbRCn1lFB8wMOJaG1x1thXKMrevWT0ms0
         hpZruwydEfi0F9WxxMZpPac+GUthpOh8mHoHGrlf1AMan43rswW9kkN6thRUH7G0IBmm
         e1HzqXYeflvzjqUPo7Wq+25k4lB41p3aY98kI7Mib+RyZqESnDRSDejIrbxTNXC9cJOX
         Yxpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rhANxfNQ/ituVJr7EmvsE6S1nIqGh/dAoPOGlDajFpg=;
        b=XSRTHz9rCYzg/BJKeo/KFloJl/7t1OTR3Od+fowqTTnpxJEI5Te85dwwEz8qB6Y1rE
         zfLwO8SLoqHdMdRdoFH6T2ROE9diCOLEwyOI0s2kdlfklVpBx1ApMo3LDaGWOsUy9JAg
         WhTZ0eHs3nEFhRDqZhUL625hDdbGChOgUnEAB4u659X2OShhGherNIRKW0s7RWLgPMG/
         +q1d4G3UOCvgHKc2C9YxPF2oSUPHFbUhaPGLRSPbxvXg8vbiQK9MrwkDHG5h++erv3UU
         RL2od2zvKkRqqSEzfREvkTLoRjH75uCWdRiRX+P4ysGf4sV48xFRuRyLDCVOrPZBiIr2
         O8TA==
X-Gm-Message-State: AOAM53104w5urwDdtPSf/xYC1oYxiB9h27L2KT3G79DBYLjIDSfOaFAb
        FwVIxqXbXmKsLnvMRGGgmyM=
X-Google-Smtp-Source: ABdhPJyHkk8aJciMlteyB0UXe/jCYNAyj8D49iUOk0DxEfBRYt0rsz8ibbhdXiPo9t3nM2KsyeNJAQ==
X-Received: by 2002:a17:903:310d:b0:14f:ef77:d685 with SMTP id w13-20020a170903310d00b0014fef77d685mr5696647plc.163.1645768660885;
        Thu, 24 Feb 2022 21:57:40 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id m6-20020a62f206000000b004e152bc0527sm1493954pfh.153.2022.02.24.21.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 21:57:40 -0800 (PST)
From:   Menglong Dong <menglong8.dong@gmail.com>
X-Google-Original-From: Menglong Dong <imagedong@tencent.com>
To:     dongli.zhang@oracle.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@gmail.com,
        edumazet@google.com, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org
Subject: [PATCH net-next v3 4/4] net: tun: track dropped skb via kfree_skb_reason()
Date:   Fri, 25 Feb 2022 13:57:32 +0800
Message-Id: <20220225055732.1830237-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <edddb6f9-70d1-4fcf-5630-cbdfe175e8ee@oracle.com>
References: <edddb6f9-70d1-4fcf-5630-cbdfe175e8ee@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Hi David,
>
>On 2/22/22 6:39 AM, David Ahern wrote:
>> On 2/21/22 9:45 PM, Dongli Zhang wrote:
>>> Hi David,
>>>
>>> On 2/21/22 7:28 PM, David Ahern wrote:
>>>> On 2/20/22 10:34 PM, Dongli Zhang wrote:
>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>> index aa27268..bf7d8cd 100644
>>>>> --- a/drivers/net/tun.c
>>>>> +++ b/drivers/net/tun.c
>>>>> @@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>>>>  	struct netdev_queue *queue;
>>>>>  	struct tun_file *tfile;
>>>>>  	int len = skb->len;
>>>>> +	enum skb_drop_reason drop_reason;
>>>>
>>>> this function is already honoring reverse xmas tree style, so this needs
>>>> to be moved up.
>>>
>>> I will move this up to before "int txq = skb->queue_mapping;".
>>>
>>>>
[...]
>>>>
>>>
>>>
>>> While there is a diff between BPF_FILTER (here) and SOCKET_FILTER ...
>>>
>>> ... indeed the issue is: there is NO diff between BPF_FILTER (here) and
>>> DEV_FILTER (introduced by the patch).
>>>
>>>
>>> The run_ebpf_filter() is to run the bpf filter attached to the TUN device (not
>>> socket). This is similar to DEV_FILTER, which is to run a device specific filter.
>>>
>>> Initially, I would use DEV_FILTER at both locations. This makes trouble to me as
>>> there would be two places with same reason=DEV_FILTER. I will not be able to
>>> tell where the skb is dropped.
>>>
>>>
>>> I was thinking about to introduce a SKB_DROP_REASON_DEV_BPF. While I have
>>> limited experience in device specific bpf, the TUN is the only device I know
>>> that has a device specific ebpf filter (by commit aff3d70a07ff ("tun: allow to
>>> attach ebpf socket filter")). The SKB_DROP_REASON_DEV_BPF is not generic enough
>>> to be re-used by other drivers.
>>>
>>>
>>> Would you mind sharing your suggestion if I would re-use (1)
>>> SKB_DROP_REASON_DEV_FILTER or (2) introduce a new SKB_DROP_REASON_DEV_BPF, which
>>> is for sk_buff dropped by ebpf attached to device (not socket).
>>>
>>>
>>> To answer your question, the SOCKET_FILTER is for filter attached to socket, the
>>> BPF_FILTER was supposed for ebpf filter attached to device (tun->filter_prog).
>>>
>>>
>> 
>> tun/tap does have some unique filtering options. The other sets focused
>> on the core networking stack is adding a drop reason of
>> SKB_DROP_REASON_BPF_CGROUP_EGRESS for cgroup based egress filters.
>
>Thank you for the explanation!
>
>> 
>> For tun unique filters, how about using a shortened version of the ioctl
>> name used to set the filter.
>> 
>
>Although TUN is widely used in virtualization environment, it is only one of
>many drivers. I prefer to not introduce a reason that can be used only by a
>specific driver.
>
>In order to make it more generic and more re-usable (e.g., perhaps people may
>add ebpf filter to TAP driver as well), how about we create below reasons.
>
>SKB_DROP_REASON_DEV_FILTER,     /* dropped by filter attached to
>				 * or directly implemented by a
>				 * specific driver
>				 */
>SKB_DROP_REASON_BPF_DEV,	/* dropped by bpf directly
>				 * attached to a specific device,
>				 * e.g., via TUNSETFILTEREBPF
>				 */

Aren't DEV_FILTER and BPF_DEV too generic? eBPF atached to netdev can
be many kinds, such as XDP, TC, etc.

I think that use TAP_TXFILTER instaed of DEV_FILTER maybe better?
and TAP_FILTER->BPF_DEV. Make them similar to the name in
__tun_chr_ioctl() may be easier for user to understand.

>
>We already use SKB_DROP_REASON_DEV_FILTER in this patchset. We will use
>SKB_DROP_REASON_BPF_DEV for the ebpf filter attached to TUN.
>
>Thank you very much!
>
>Dongli Zhang
