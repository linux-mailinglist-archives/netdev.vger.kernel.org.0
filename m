Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1394127619A
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgIWUEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWUEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:04:31 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D1CC0613CE;
        Wed, 23 Sep 2020 13:04:31 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id m12so981026otr.0;
        Wed, 23 Sep 2020 13:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tWFTRPGRADrzoMZdwPoL2+bgLbryjFmfVhl1CEqG3MI=;
        b=H/Kl2zus7FVSswFF53vmCD0QsrSzotKuokB1wNksbnvnH9og8cB2HCuJz8XX9GJ0DO
         YlZTY2X+m1qigAvdFeZg6d2b7mTzJXG8rH0cygMRtWpkj7YjGL9aPxoTZrTYl5fFmri0
         Wgzhwv9IqwgoHQvF+RBL9GCxPeLL5187VqUSDtCt6bsySbzwWlIqGBllG0ZOsVkPUWI4
         F5+u4XBB6yvR8OO03diFOuahXMoAIqSbndttN9H/XaTwQiO0IuUyuX8B9DJLIbQ5E0VE
         ofvC5FgO7CdzUs2k2hCRLjOB3l1dv1OAFfLIIl22M4hoD8ILrJUr+SDYNDts6cne+5Le
         JkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tWFTRPGRADrzoMZdwPoL2+bgLbryjFmfVhl1CEqG3MI=;
        b=tkN78hTbPsZoAD5/c2+L3DTYTUV/BrTMGEfkCMD/y9FgL3BIifQKgP1N6GpywspcbN
         jat20HkjamrhP5qQrBihKWhZsUMVrvMW3rbCuL8Y2WSEBl7D7Cq58CQfIahaNW883Vpi
         oTE08wznm8ZvE9vxtNTMIc9f8JiQlw9lNY6Coa2Br6iNoG4gcbPiIyep40/yfS4nIJHp
         BCSbllz/aMrfl429XzIXiuQAlfgyRXhB7qpz8GMiINoCBOA+zGgKtS/yD8sOhVNATYtO
         3P8YjHEix229JFmqYy+5aAEVE7VNwiZ+WfwkpHZxAT+iWEuYa1KctKkTkJdfCQADUES3
         wpCg==
X-Gm-Message-State: AOAM530EmWcB/HLUfO7I0aaVbH/Kclwa4sWUkUK6QINQkTN/XmHNuPtM
        yi+u6/bkLLF8Uz/Z2IUO4LS08NDwk0HZCA==
X-Google-Smtp-Source: ABdhPJyNyKJp1mAVP9Yn6o6gUWNZ9z4u1VU2dKLdLQSr2IgPEmEg3hifpRA5CCAUZhh8bErBcbw44w==
X-Received: by 2002:a9d:787:: with SMTP id 7mr882320oto.202.1600891470706;
        Wed, 23 Sep 2020 13:04:30 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:1068:a73e:c386:fe1d])
        by smtp.googlemail.com with ESMTPSA id b4sm169670oic.8.2020.09.23.13.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 13:04:30 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] l3mdev icmp error route lookup fixes
To:     Michael Jeanson <mjeanson@efficios.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     David <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200918181801.2571-1-mathieu.desnoyers@efficios.com>
 <390b230b-629b-7f96-e7c9-b28f8b592102@gmail.com>
 <1453768496.36855.1600713879236.JavaMail.zimbra@efficios.com>
 <dd1caf15-2ef0-f557-b9a8-26c46739f20b@gmail.com>
 <1383129694.37216.1600716821449.JavaMail.zimbra@efficios.com>
 <1135414696.37989.1600782730509.JavaMail.zimbra@efficios.com>
 <4456259a-979a-7821-ef3d-aed5d330ed2b@gmail.com>
 <730d8a09-7d3b-1033-4131-520dc42e8855@efficios.com>
 <47175ae8-e7e8-473c-5103-90bf444db16c@efficios.com>
 <cfdc41d9-cca1-7166-1a2e-778ac4bf8b73@gmail.com>
 <b86a635d-774e-9e9b-a8bd-7abe3eb9a26d@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ab8b09ef-fab1-5b2b-fdb3-67e6788bc7c7@gmail.com>
Date:   Wed, 23 Sep 2020 14:04:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <b86a635d-774e-9e9b-a8bd-7abe3eb9a26d@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/20 1:12 PM, Michael Jeanson wrote:
> 
> Just a final clarification, the asymmetric setup would have no return
> route in VRF 2 and only test the TTL case since the others would fail?

correct. add a statement about it representing a customer setup so it is
clear such a config is a 1-off
