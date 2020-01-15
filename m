Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA4913CBC1
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgAOSM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:12:59 -0500
Received: from mail-qv1-f42.google.com ([209.85.219.42]:46948 "EHLO
        mail-qv1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbgAOSM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:12:58 -0500
Received: by mail-qv1-f42.google.com with SMTP id u1so7785699qvk.13
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zlv/jO7f2mO5feEJUd3uM89sV3/+wgZSIGPPJx+ZjY4=;
        b=BNZHDHf0MNNrpVO+lN3V+cafX5upA2s89kyi6WLAbjDt5/ChZUqccUqmcQsalr8Oe8
         YMSzRv2ydEC9CcoWdcen9XAfNxBlrFgZK84LdY62Fnz5JzGZWzT44cBenPGeVwKYjOYL
         9SWsTMVRZChbGJabKXCUuLfSNS/cuAAFNmjr/18frZgiZaOJG2VTADPQCiYGCE9HjWjR
         F9++xxtBgFPr/ItzJB83p6TnkhCTYRAjclIk1MGj7HttRs41CEjoE2x90shuO+ykxSDx
         TQr7HR4G4f4TY+rEmlrzoaxSg49W4hiyCNHwjDhKvFtjfLP3KdHsRAk2rVrABorT+ODI
         mtww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zlv/jO7f2mO5feEJUd3uM89sV3/+wgZSIGPPJx+ZjY4=;
        b=OCtm1zpkXczQzVsMipTtrke2d9dFpfYouF5tpXd22f3MVD2mUBBFIEerKH3xsDFysA
         hRgAd1vSyiDRoytrpE59RwyoKhJADugvvWKWPWiZxITxeLClWoWSMPzmnuiHssA9MnIZ
         7y4b3vgTF0tKhdHLCL+gV3y55xWzge3MdodtXvChUldFMD8Owof+a5TpbibHzWVKzSyF
         zyxYUB18hgfIET2uRQeUCx+GENJ3kiHCubzZ54Wb33QAl8xaQm1klIKzGBiTDnroDmUw
         ex9vE/v6F0L4Dije/tuEdFlE0UWwgzgqTmuVmcHzI4wFI7PdCPSo6GDDa2Whtu9ymGLW
         kx+Q==
X-Gm-Message-State: APjAAAXlWIBI/Ph833cGRIjFRml3R3frHzmIBwhXoNiodBcm5XrFHOLT
        sE/63is/1faGZetquMdp8lQ=
X-Google-Smtp-Source: APXvYqyuuA4NlUaFhiQd64QfTX492ikCXVAyKHgXY4mWRK1k92TeH1rVvxZXsULSvnPxTjGzkYhOyQ==
X-Received: by 2002:a0c:e4cc:: with SMTP id g12mr27366518qvm.237.1579111977713;
        Wed, 15 Jan 2020 10:12:57 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:b4a4:d30b:b000:b744? ([2601:282:800:7a:b4a4:d30b:b000:b744])
        by smtp.googlemail.com with ESMTPSA id x8sm8763956qki.60.2020.01.15.10.12.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 10:12:56 -0800 (PST)
Subject: Re: Expose bond_xmit_hash function
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leonro@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
 <20200115094513.GS2131@nanopsycho>
 <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
 <20200115141535.GT2131@nanopsycho> <20200115143320.GA76932@unreal>
 <20200115164819.GX2131@nanopsycho>
 <b6ce5204-90ca-0095-a50b-a0306f61592d@gmail.com> <26054.1579111461@famine>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4c78b341-b518-2409-1a7a-1fc41c792480@gmail.com>
Date:   Wed, 15 Jan 2020 11:12:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <26054.1579111461@famine>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/20 11:04 AM, Jay Vosburgh wrote:
> 
>> Something similar is needed for xdp and not necessarily tied to a
>> specific bond mode. Some time back I was using this as a prototype:
>>
>> https://github.com/dsahern/linux/commit/2714abc1e629613e3485b7aa860fa3096e273cb2
>>
>> It is incomplete, but shows the intent - exporting bond_egress_slave for
>> use by other code to take a bond device and return an egress leg.
> 
> 	This seems much less awful, but would it make bonding a
> dependency on pretty much everything?
> 

The intent is to hide the bond details beyond the general "a bond has
multiple egress paths and we need to pick one". ie., all of the logic
and data structures are still private.

Exporting the function for use by modules is the easy part.

Making it accessible to core code (XDP) means ??? Obviously not a
concern when bond is built in but the usual case is a module. One
solution is to repeat the IPv6 stub format; not great from an indirect
call perspective. I have not followed the work on INDIRECT_CALL to know
if that mitigates the concern about the stub when bond is a module.
