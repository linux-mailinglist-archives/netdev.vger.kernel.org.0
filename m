Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D20520139
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238446AbiEIPgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbiEIPgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:36:31 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817DA22B381
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 08:32:35 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id o190so15712223iof.10
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 08:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=TOaQe1lFBwWriM859k/6A5tDyrlYFX+JC99w6o3+CPc=;
        b=OGwh/9Z0ulfk/O3LO/gVtg0KRlQMinOyUHV1gLqWv75AsljpRLyVZcWEtHEQ51AIRv
         9ugBpSNN2UyCo5virDZmczPFASNZGi92ug6s6wB3IDJqbjeuH8pnbbygRgHtusBiQxe+
         msxfX/GMX/2TmmDQXbxn7lx0uws6etDhk0B48DvtbfODAiKH92hot0pItwkV1hEw2FFr
         VVnDnzplzigkjaxGO7VLd1nByD6cCGHrO2lmBLpyMyLFa3Dtt80oZsFxKnfoyW046OHb
         eLxD33cvhaPAqqLzHcmE/BH9GCMLNJdsu2+sFR4b7iPfe1kRyrdDcOCLrIMxjU0Gyier
         ClBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TOaQe1lFBwWriM859k/6A5tDyrlYFX+JC99w6o3+CPc=;
        b=dvYyYXimaIn7tCAk3UkrXrFlW6ikHzG7AH0DYOrNe4fWxfOYYX37StfoDbeW+E1wxG
         PzhdL8SbcO0gi0X3X83RKnfqtNjwsHClUOUxkndY0ETyrajHj2iWIzmufbN4i2Bphjzv
         ENN2GeaCurNSE+b261djaNf1zfcGntzOGCtf257TJZqzzZvNRrge+O8so77AdG+VNeJe
         n2/+UzRo52Gt+UAXkqGCbXU//1TC0i0ryuhaxduxanjt4CS8NISzscwvDQ5dsKxEiu9U
         8s2X8vh8Q9ghLkUkosHExLnzY9868aioFOm3dBSzJxUyv/w3OWlcBc3/mJ9/v8FughZi
         DEsQ==
X-Gm-Message-State: AOAM530t6kLJ4WdspDErK8FzPCWxkgjTKGbjAI7+Jp/gHPCRRk7y8fXx
        hyPN5w3J0JcFJ2z9nMS62iTUfTrYDLY=
X-Google-Smtp-Source: ABdhPJw68J7xw/LRltQfwbkK6ef8guXhZkKSQBd82bPIZQvB20hYIBGq55X52SRTwayoIxS0bHzZ0Q==
X-Received: by 2002:a02:900d:0:b0:32a:ec66:4fa7 with SMTP id w13-20020a02900d000000b0032aec664fa7mr8071839jaf.271.1652110354821;
        Mon, 09 May 2022 08:32:34 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:e970:4f57:6d9a:73c8? ([2601:282:800:dc80:e970:4f57:6d9a:73c8])
        by smtp.googlemail.com with ESMTPSA id r21-20020a5d96d5000000b0065a47e16f41sm3558617iol.19.2022.05.09.08.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 08:32:34 -0700 (PDT)
Message-ID: <0c2d516e-548d-15bb-6c94-84a70a882f9b@gmail.com>
Date:   Mon, 9 May 2022 09:32:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: gateway field missing in netlink message
Content-Language: en-US
To:     Magesh M P <magesh@digitizethings.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220504223100.GA2968@u2004-local>
 <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220504204908.025d798c@hermes.local>
 <DM5PR20MB20556090A88575E4F55F1EDAAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
 <DM5PR20MB2055F01D55F6F7307B50182EAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220505092851.79d3375a@hermes.local>
 <DM5PR20MB2055542FB35F8CA770178F9AAEC69@DM5PR20MB2055.namprd20.prod.outlook.com>
 <DM5PR20MB205570BAE36B6ECE25906567AEC69@DM5PR20MB2055.namprd20.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <DM5PR20MB205570BAE36B6ECE25906567AEC69@DM5PR20MB2055.namprd20.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/22 12:59 AM, Magesh M P wrote:
> 
> 
> 
> 
>  
> Hi Steve/Dave,
>  
> Thank you very much for great support and sharing the knowledge.
>  
> Dave referred me the file iproute.c but this contains the flow from user space to kernel.

the reference is to a print function - dumping the state of the route
received from the kernel. It's caller parsed the message. The 2 have
everything you need to understand the message getting sent.
