Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3F7383949
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345511AbhEQQNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347102AbhEQQLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 12:11:01 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF17C0494DD
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 07:47:05 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso5715717otb.13
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 07:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WQTOJ2Z9Nz7rspDFxgz4uoKuKjRMTaOcg9U3rxA4Nbo=;
        b=GWY8piwhdN9NNfExBQO93USQPfJBHg+3fAPJZN5ubwe36FrX/9Mh/eh12sNz1JOlZO
         QI0a7E3pCdMqgTdQB6GRoiNLCEdanpuItucg7EHQOWZhCyIVfyE86WmAmhZ6+8PEEjlC
         sPtph1kDddqZ+syQ3PlOJ5dB+2/vXvj+NkwgiiUrSB51HJ8/TJ+C7y4h5efcfJLUrxMI
         abbnCazkfpjSOe5kLEAGxwypsw6x+uPDy2bX+melgeTyn0LaOKWpCWJa5e+eiUDhtTGS
         LXr508w5mtEpFA4Rs02g2Vz/vOOloW+hWcdDG+05ol5Q08vdJsE3BqaAgyNvoGsfL14T
         H5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WQTOJ2Z9Nz7rspDFxgz4uoKuKjRMTaOcg9U3rxA4Nbo=;
        b=bFEAQi+pCerTaRCpdK07XrDBYgT0MT5j/7nvZHygMu2JS3KQxLum7OoO95zgM4zKy3
         peERHBLp0yLzwQ+JqiTu/IHOu01G3py9DOdm2Pt2w/3mCkLpnLi4g26KrFYmC4LgI8HM
         11E6xBc8TgdeLhU8G7T+IFGQ7h/w7ItFXN8p+nMmtVL0QFKIhDPCAD1+fzhhuUK5DCnz
         CkG7BMsEPZ7ChxkX0fOZO+Wayl5TrKOrli2bRJcEPFIqb0ra9NRqWDVD8fnvvkdrRG6B
         UU7JEJp13dgtGsazomupVJvnQWG2z2ofZHnddjgRBOCxTJQmzmHVkRsuxAKWfokkE0Qq
         a/vw==
X-Gm-Message-State: AOAM533jyl1OVgabCnpmDAx04tVq+z8DHHHTRefJI0r5GhvjkgJ5WwTs
        Ogm7uAw3B3kq1HvPtYyqmYI=
X-Google-Smtp-Source: ABdhPJyf0v0KFvmj6J1J+1fDO409kqk5J03OWPg76W+vj6u0uFoKrdgSF1dX+WtPv4xjm/H9IRs2NA==
X-Received: by 2002:a05:6830:1695:: with SMTP id k21mr28570158otr.2.1621262825214;
        Mon, 17 May 2021 07:47:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id t23sm2730130oij.21.2021.05.17.07.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 07:47:04 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v2 02/10] ipv4: Add a sysctl to control
 multipath hash fields
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20210509151615.200608-1-idosch@idosch.org>
 <20210509151615.200608-3-idosch@idosch.org>
 <95516cbb-1fa3-566c-62f9-ae6adcbf8fe9@gmail.com> <YJrjf7yj3+Xj5KhO@shredder>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ca40232a-ce77-ce02-5e30-357224edfd4a@gmail.com>
Date:   Mon, 17 May 2021 08:47:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YJrjf7yj3+Xj5KhO@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/21 2:05 PM, Ido Schimmel wrote:
> 
> # sysctl -w net.ipv4.fib_multipath_hash_fields=0
> sysctl: setting key "net.ipv4.fib_multipath_hash_fields": Invalid argument
> 
> I assume you want to see this change in the next version (and for IPv6)?
> 

Yes, I do not know of any reason to allow the hash policy to disable
multipath routes.
