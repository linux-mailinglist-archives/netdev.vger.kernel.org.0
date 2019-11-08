Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57144F5A98
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbfKHWIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:08:45 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41183 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfKHWIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:08:45 -0500
Received: by mail-pl1-f194.google.com with SMTP id d29so4741395plj.8
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 14:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lG1xlX5D1aRGViazl8UoM3ech3donnwQAfj5bt3MJsU=;
        b=lSX3aYZERhsK3cRHZ/kT5d806YsqPFXjmyzVbYw7agl2GoBNbIMgAgE1/lqvdq3ylF
         +HqHgMWzXzluVePo75DKH7qeYnNH9xhv8pFsC8rtbmRfTukREBif6TB2j6ug17eqwAG6
         hnI7VKxWpHUVGatPm6qyKE6YQpXHVcOCcjtSRIktmRrb+OUCwSZ5rq92sRH+BpapIKTb
         PPOtwaTBtIIAmiCvaaCcAKk7qA8pE7sut4AgOhmvsh3EyEGJmY0XY7I6GrwlmXDOu8W3
         XKkv/kQZGWxMjyZ5VgKUZItxTLZZLV/gJrRCfoxtjU9+Cn0xLP/NR39SlI24hwxDQws7
         C2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lG1xlX5D1aRGViazl8UoM3ech3donnwQAfj5bt3MJsU=;
        b=djKRsaz8SW3F0F9v9NaIhdI7NccPGxuQuWMn3/DSiYFPCC/qnYYil3L2etOejw9Orx
         52vgJhwCg1Lfa0l+9V1x10GUkRM0RUkk3/yEZmZiN7sHl7BwDkkujF6l+39o4UceeLAd
         NggljTZiw/A/WXiylYkV6q7CwCm4wzLbQkjdtPqDG9pRaYEsuL/A1e+YTEP46WHlhsI7
         5gQKAnaKqg2AH73nuQbeTXmgxnlaf5Wli3fMRrLMkm23d8pL0c9KXYynp6wXEQor5GGS
         lKBaNc6IuN6Iy4ZuACdg5mujfAwLYO52suK9vOsRXovESYe7wOM+IZ8nwz16OcFRXqKv
         DdbQ==
X-Gm-Message-State: APjAAAVFxA9KwwATM2PgFFiD0hTYalqyWWhiwlPlYtXAOSYoUQFOdCqr
        2pAdPQy4KsQFa+OqpposI2XIlg==
X-Google-Smtp-Source: APXvYqw7UuNbJavqD966BDvBafHD0K6Vkque6WSGHkFKLUOUP5e6oSSHPfZkQDLZVMiQqTCpi2JXlQ==
X-Received: by 2002:a17:902:9a92:: with SMTP id w18mr12925769plp.186.1573250924593;
        Fri, 08 Nov 2019 14:08:44 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id h8sm13299761pjp.1.2019.11.08.14.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 14:08:43 -0800 (PST)
Date:   Fri, 8 Nov 2019 14:08:43 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/3] Add support for memory-mapping BPF array
 maps
Message-ID: <20191108220843.GA1449846@mini-arch>
References: <20191108042041.1549144-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108042041.1549144-1-andriin@fb.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/07, Andrii Nakryiko wrote:
> This patch set adds ability to memory-map BPF array maps (single- and
> multi-element). The primary use case is memory-mapping BPF array maps, created
> to back global data variables, created by libbpf implicitly. This allows for
> much better usability, along with avoiding syscalls to read or update data
> completely.
Just wondering: is it something that you plan to extend to other map types?
