Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7981595349
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbfHTBVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:21:05 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32808 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbfHTBVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:21:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so2277883pfq.0;
        Mon, 19 Aug 2019 18:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DoQFin37135Z6VBGqAekmMIb4mcG5LwSlT3kSlC4tuE=;
        b=DVwQtopPoVKc6IEveihYO0lstzuyuUoZxUE/GE5gIGuqtIZz1d4U5JtnJhRAtd0vJV
         GVMBnAtB6V05k1o6hsacVDEyZHjONZo/0PoKsmqF548CKX/iTdJdNgHEaXTTCy6///84
         CayjShdOTz7g9yHZTNspu2/lz/S/0Q4aSPYik3XQQ/15zBpAytFZ0+bJ0cuyi0WNjzd1
         7Rc54ly0rIgp1zDf7Ix7txPu3YiGmo9KxXy9wspPZecu7hCaE8SHcpJCNVm8G8rpVDRZ
         KB1N0uA1IIGd062Uo8jYigTqUf0CDMvFP8xMmXrOcv7+dq4tG5oIWI0dlsjFytVJEvjO
         R0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DoQFin37135Z6VBGqAekmMIb4mcG5LwSlT3kSlC4tuE=;
        b=YzKS3bQzsLPmnOXYTzdLiVlO8Bg4/P5B95aYQCjJYOUj5rcz7MxMkWclCEWQcHwJie
         99Z832NBEuMOLqgfUuePKdFHH7Zv04o+mfVKvYqmqyQka74QxEU8EsFQt5i2yAQMKMgH
         sr/oPaTCNsYMY1KmgXFXB1ATwNRsE7BY7fBAnXtUelAWQeDNKPRSzP5GqzR5H0+ROANM
         qSQnahvIi1O6/ersjaynuabyefOHrFIkCz3A85Xa5jVwGKzokDkFBWK8FWz0QyyeU2oN
         L3O6aHbhFp3aPxIja6fHy/7sOmrSXaEhpWWfdiHpFWHwWjVe5ZK0hcTrzz3I5QDBnq6H
         oIzw==
X-Gm-Message-State: APjAAAUqOjzpo+eWjMRi8/mWUmNGbs2NN+yYDO67QxVy5Y3dEPNntAur
        4iax1iVXZI4fr5n2D7ZdFEJBywHr
X-Google-Smtp-Source: APXvYqwVDXXoFtsQOyXjyPTng/Vz09vNRnsBtj5j0H+b6zgCnoMzpfcyIxPYbxoh3Tyy6U6neysbCA==
X-Received: by 2002:a17:90a:aa98:: with SMTP id l24mr23394393pjq.64.1566264064518;
        Mon, 19 Aug 2019 18:21:04 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:3489])
        by smtp.gmail.com with ESMTPSA id v14sm17036402pfm.164.2019.08.19.18.21.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 18:21:03 -0700 (PDT)
Date:   Mon, 19 Aug 2019 18:21:02 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH bpf-next 4/5] libbpf: add bpf_btf_get_next_id() to cycle
 through BTF objects
Message-ID: <20190820012100.yeg7qfjy5jbv6pxm@ast-mbp.dhcp.thefacebook.com>
References: <20190815150019.8523-1-quentin.monnet@netronome.com>
 <20190815150019.8523-5-quentin.monnet@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815150019.8523-5-quentin.monnet@netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 04:00:18PM +0100, Quentin Monnet wrote:
> Add an API function taking a BTF object id and providing the id of the
> next BTF object in the kernel. This can be used to list all BTF objects
> loaded on the system.
> 
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
..
> +
> +LIBBPF_0.0.5 {
> +	global:
> +		bpf_btf_get_next_id;
> +} LIBBPF_0.0.4;

please rebase.
The rest looks great.

