Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6A78194EF2
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgC0CbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:31:05 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46324 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0CbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:31:04 -0400
Received: by mail-pl1-f193.google.com with SMTP id s23so2888959plq.13
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 19:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ijdOLDaoqn9Xco4RekNbgelG9nPGltRY3a2CPwMCbxw=;
        b=rxwIVvD4M9gb6EVEimBZ/186HGKofk6ocvIywUeL7v1ICC+naOnOHOyIVBbRpZPrGC
         fmTn1d5Vjzvaz1bYOwZ/e6jqINrAK0iQOPLRlij8MdERwJabMMfYw952+av6iOqqzU0u
         kdqy8+oMu5p8ZOmDuS2RHEoKgmYEJ4GXBwB+zt7/ymqQkcogdcvttbWOZhHd16gsS0WB
         GYW5v7z8KNUQjpON9VJ9elPkO/Ox7c1IYZ1MCApovMtSmMZhVBuStTydw5Z4dt0fiIRX
         fe0Io/e96FObUqXxcJkOcrHjcj4tylEITOCP0yJzCaLnlD/MI6WKsjChkOnw8aLTqb2L
         tFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ijdOLDaoqn9Xco4RekNbgelG9nPGltRY3a2CPwMCbxw=;
        b=pr00mWXIr2Zv0uinwkzvM6No0ium1c16fFrnE/KWo6LCTTw76kC34CP9KmMWvH93c0
         WubMBlQPmtfw2yUMo4OEnp0HPd9fcHrdNziNhfcQDfaHRMbBs6wV5ILZ43s9p4xbLShP
         MbbAEELjoESRcq3jtyIGHblHXLam8xXi+0iau/GvoGH25CZeTuN5MvvSybaNoTbcIXLI
         uDlyO4Hi9wGzwJCz+H2KkT1aFRjJ/sMi6wkBJvN9SuA3hzUsIqrAsDdoCOpoy+GMXsXB
         AZ2uPXw/M7vmcxl0F/491kWpJ1A/pEeAnpVdkyAPTw2FgADiLirRRJqpe+GNg9oDt3DQ
         udOg==
X-Gm-Message-State: ANhLgQ0tJAj56o+/R4kY48XQJQ1aqihzv3nkPSFjuBr5hREH4knELVLV
        S8bRwiHbLsq+nz1Yefobsig=
X-Google-Smtp-Source: ADFU+vsjkaEYMm5XP17B5hNm2NJOqqSHFcPorrGr+MXfNWASBQMQsrwaa63t0BNtQwo1loFp/OUCrQ==
X-Received: by 2002:a17:90a:b003:: with SMTP id x3mr3322956pjq.140.1585276263546;
        Thu, 26 Mar 2020 19:31:03 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id m11sm2609197pjl.18.2020.03.26.19.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 19:31:03 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 2/2] veth: rely on peer veth_rq for
 ndo_xdp_xmit accounting
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, brouer@redhat.com, dsahern@gmail.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com
References: <cover.1585260407.git.lorenzo@kernel.org>
 <7cb6b8d1b3a145a4a5cd34a8350a15727fd1f735.1585260407.git.lorenzo@kernel.org>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <e8783ef5-ce64-df2e-1cde-d9edb82c62f2@gmail.com>
Date:   Fri, 27 Mar 2020 11:30:59 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <7cb6b8d1b3a145a4a5cd34a8350a15727fd1f735.1585260407.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/03/27 7:10, Lorenzo Bianconi wrote:
> Rely on 'remote' veth_rq to account ndo_xdp_xmit ethtool counters.
> Move XDP_TX accounting to veth_xdp_flush_bq routine.
> Remove 'rx' prefix in rx xdp ethool counters
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Thanks!
