Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EC517351B
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 11:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgB1KQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 05:16:44 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34500 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726063AbgB1KQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 05:16:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582885002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eVoGLbtnYzXWlmc48w0t/0qrnxkTvQefS/f9aokidUA=;
        b=I25S4OL3W5DO/IKq0F2mP5ltH69hg4MKpfS+/8+cj9ye+vJVfpZKZ3PcJowdeH2peYxrgQ
        TIGm6/brjWVvb3Ym84ZzqiP1oqg6x0rvu9XTZovG1BsMPzDGTXNuDFEkL0B5Xcvg2eP9cp
        oRP9U04JZOtqZ+W7AwuM83S+qBSv/+k=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-tuTwk0sjNwapV7gtUNxV2g-1; Fri, 28 Feb 2020 05:16:40 -0500
X-MC-Unique: tuTwk0sjNwapV7gtUNxV2g-1
Received: by mail-lf1-f72.google.com with SMTP id r24so341826lfi.23
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 02:16:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eVoGLbtnYzXWlmc48w0t/0qrnxkTvQefS/f9aokidUA=;
        b=KK2xjndRNeaYyPIx2TYh/4k/cPiiyhZAtZRAF4XJLlRzLCHajHN4WAcg5FZVOsl1LR
         StACxUYIg45YHKflgqPZ3D1GqPIQ9vi9UdGPCVgVBMLROD8BYpcn6SZ9kyFa10SS13IB
         PSVFlUBgJmidGfGnmoXwo2FH7K31ddh5dYYJy4xUhgZba5+HOnirOLeJbiLZHVNhRl9C
         ZKdHo+NQW0KOMrRBTZBj0/LfLgEgxR4DCvimncKV+VSpVc+m/NvKZH+0dFDv1ldDn73J
         /Ek6lHwpFAd+pUXv5v/1gg1yB44EIAWdeRxVp6b3lTTLhsjj6ZNZdpQbtsxt1B+TYnhL
         9Fkg==
X-Gm-Message-State: ANhLgQ3t01ku/wZKXep2QcRWr2PE3lpXS4zwV5m4bPH1I/eKLNvSpDps
        uP61xXJS6bSyvKYusA8RKKjBKQl0T+m6cHsa/+CgIbRChCybnQXnRVpdToKbQmMXXcGDowgL2Hw
        k9NYVtYrT7l9I87RP
X-Received: by 2002:a19:7d04:: with SMTP id y4mr2282663lfc.111.1582884998571;
        Fri, 28 Feb 2020 02:16:38 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvXO5F7cH4hg0ivZxLRqZGLTBjzmF9Evdui+BrIiVguCGiV5KpQodnEEMWnFVLVq1UTeuRPKQ==
X-Received: by 2002:a19:7d04:: with SMTP id y4mr2282655lfc.111.1582884998373;
        Fri, 28 Feb 2020 02:16:38 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 19sm4543665lfp.86.2020.02.28.02.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 02:16:37 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AC741180362; Fri, 28 Feb 2020 11:16:36 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Luigi Rizzo <lrizzo@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, sameehj@amazon.com
Cc:     linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Subject: Re: [PATCH v3 net-next] netdev attribute to control xdpgeneric skb linearization
In-Reply-To: <20200227173428.5298-1-lrizzo@google.com>
References: <20200227173428.5298-1-lrizzo@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 Feb 2020 11:16:36 +0100
Message-ID: <87h7zbuid7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luigi Rizzo <lrizzo@google.com> writes:

> Add a netdevice flag to control skb linearization in generic xdp mode.
>
> The attribute can be modified through
> 	/sys/class/net/<DEVICE>/xdp_linearize
> The default is 1 (on)

Calling it just 'xdp_linearize' implies (to me) that it also affects
driver-mode XDP. So maybe generic_xdp_linearize ?

[...]

> +
> +What:		/sys/class/net/<iface>/xdp_linearize
> +Date:		Jan 2020
> +KernelVersion:	5.6
> +Contact:	netdev@vger.kernel.org
> +Description:
> +		boolean controlling whether skb should be linearized in
> +		generic xdp. Defaults to true.

Could you also add a few words explaining what the tradeoff here is?
Something like: "turning this off can increase the performance of
generic XDP at the cost of making the content of making the XDP program
unable to access packet fragments after the first one"

-Toke

