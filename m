Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CF21B2867
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgDUNt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728479AbgDUNt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 09:49:26 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF856C061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 06:49:25 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id p10so5490784ioh.7
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 06:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bVTo9SLy63nImfyhLx2YimdnlXKn7XPgOlPja3dItzs=;
        b=FgGb2ApNxXJzbS9D4gyj5hUcbmy3aVAR9kvSydXZLCc57NowXWUgJ+Masmr5yNPx2m
         o9uyUQInIdCjlIvAiZhnJPzxGE4qOnly5+0+P6I7WWApXxavK7S0hXvj6rC+IAKq/BRo
         zLqKmeljMWJ2H4tYV/VV5rH+EUmrQeN8x2fswASiPfwl7FDTwqUb6dRo11wKzc+3SkUg
         J++orq3wXCKt/KZdfEpK40Hddsxy8PcN5AVY7FCSczjWAKaH+OOhoTqpiAi2xtrqwLw0
         ADKSNdBj/b/PguamuDEyxD5ySk2ysyGH5kcpotFTsmkb0av0JihZBrqsyGRYso9iMl+6
         Zv6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bVTo9SLy63nImfyhLx2YimdnlXKn7XPgOlPja3dItzs=;
        b=TVbMrKe3NbCYhUmMWsQIXjurElQXDKSDPpnq46QenbHv7d/LqMxr1sXix4MUHboll/
         ABjiEj+LvwpDyefgj/QJ8DPpMSNcyNlRTRpLaSp1CAGVvTlX/L3iLxVZ2pWavAEMes81
         at4EXMT5mUBzDtcAwdcEK0FQizEhIendlw3209Vd2pYX9JhSQpHYiULeMmye7OrhWvQo
         nosVpsbV/3ihRN5NZPkfIWiKo6KI+drJ1gvm0pmq+oOwQoKHlRrHORZmJwvdm+RT+S+b
         oJsZeirTaHL5FzIaiWOV2MFqqNnpRewqq5LCaCOxMQN7p6bW/LHAej9okdYapiB7GUbP
         /+Ow==
X-Gm-Message-State: AGi0PuYW0i0O+QzZzrTWXbcnP8dEcvxtjXPQfpPQeSK9lOck2kD87ADS
        1rAtwtV5sqnqRFdQSUEIHDc=
X-Google-Smtp-Source: APiQypKnwP5KeSDCT+PRKnEXeCDE97iXxyi1XqXDEW9aHdm9FwSi0eHKOGwhu2RZKhGzeOFj1FDeKw==
X-Received: by 2002:a02:90cd:: with SMTP id c13mr20099294jag.83.1587476965238;
        Tue, 21 Apr 2020 06:49:25 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:294e:2b15:7b00:d585? ([2601:282:803:7700:294e:2b15:7b00:d585])
        by smtp.googlemail.com with ESMTPSA id c19sm921868ili.63.2020.04.21.06.49.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 06:49:24 -0700 (PDT)
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a
 bpf_attach_type
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200420200055.49033-1-dsahern@kernel.org>
 <20200420200055.49033-5-dsahern@kernel.org> <87ftcx9mcf.fsf@toke.dk>
 <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com> <87pnc17yz1.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com>
Date:   Tue, 21 Apr 2020 07:49:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87pnc17yz1.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/20 7:25 AM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@gmail.com> writes:
> 
>> On 4/21/20 4:14 AM, Toke Høiland-Jørgensen wrote:
>>> As I pointed out on the RFC patch, I'm concerned whether this will work
>>> right with freplace programs attaching to XDP programs. It may just be
>>> that I'm missing something, but in that case please explain why it
>>> works? :)
>>
>> expected_attach_type is not unique to XDP. freplace is not unique to
>> XDP. IF there is a problem, it is not unique to XDP, and any
>> enhancements needed to freplace functionality will not be unique to XDP.
> 
> Still needs to be fixed, though :)

one problem at a time. I have a long list of items that are directly
relevant to what I want to do.

> 
> Also, at least looking through all the is_valid_access functions in
> filter.c, they all seem to "fail safe". I.e., specific
> expected_attach_type values can permit the program access to additional
> ranges. In which case an freplace program that doesn't have the right
> attach type will just be rejected if it tries to access such a field.
> Whereas here you're *disallowing* something based on a particular
> expected_attach_type, so you can end up with an egress program that
> should have been rejected by the verifier but isn't because it's missing
> the attach_type.

There are 6 existing valid access checks on expected_attach_type doing
the exact same thing - validating access based on attach type.
