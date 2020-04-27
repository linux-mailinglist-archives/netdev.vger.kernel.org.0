Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39FE1BA133
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgD0Kaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:30:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43354 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726485AbgD0Kat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:30:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587983448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MYZR6++ueNxR+uobaz3YRdFxV1REvMETBh6qIowoIZQ=;
        b=ftZ3tWGbDGTfQ01XZS76Cd0pbP30rzGKP5vaA4Q/HEs0wbGSpx/7li393EEXH8yYktjfND
        h8ZI4U6bp0MH0m0GJW0/FWI6TOI/pUy+pFV4nTmxSf+OEqoxrrin1/4ZVy9u+5ZN1pIS8A
        ZZrQVM+VXAfsGw+Tx0r2tKV+XKaCeaM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-w5Q_ofodO9ihG_jTvzxX9A-1; Mon, 27 Apr 2020 06:30:46 -0400
X-MC-Unique: w5Q_ofodO9ihG_jTvzxX9A-1
Received: by mail-lf1-f72.google.com with SMTP id l6so7323582lfk.2
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:30:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=MYZR6++ueNxR+uobaz3YRdFxV1REvMETBh6qIowoIZQ=;
        b=ifs0BBnRRQJ9Yst/+LZSpNp9jx9AEH6XFP1qM+rmuACzR7QxN7TSuHCVHZMu3OJQJb
         ZiGUx2RbIJyEJgLN/SqCAtp/5dQJ7bDtKazXaLDovC+t9I5/a0pv3J5lmqBPNrpMEEVh
         J1hze8kgKsfTPuKtyYcuHZlyeQFlDHySTNKSjlAhNcTqLlgPMRt8rv3HPKfpYV2UdLxx
         hLhePKkEfOeseLGg6hUbsCdxdLPsIRFNp+qUIE8HLt5ZpF+jdqEfI4otRtbtNgEEz54t
         uJjd5zGqyI/fzZIHkTha05fkm8Dyn3l69rrfBdGSSzbXyL3Z1Q6F+q4XiqXeR65IObnN
         N5Cw==
X-Gm-Message-State: AGi0PuaF2UzOojsYDiE2Dhgyjd0FRRvOBAWsmB201o7K9xpAIiPSa21L
        DOyuAVjCEUeid8KIkfjgkrfkQoJPTtyt2RMka3JMdYdEHhqscqbKxfuInfGFNBwXoAk4tIni1fS
        EC7HJxmb1YHk6pqRF
X-Received: by 2002:a19:b10:: with SMTP id 16mr15240911lfl.133.1587983445010;
        Mon, 27 Apr 2020 03:30:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypIkS9jftxo8OIuDFHc7/X9aGlPgeYTwUb2DKkjBAVgn2ypWCM7I57jH3oYgL5cK72IqmdqMWQ==
X-Received: by 2002:a19:b10:: with SMTP id 16mr15240901lfl.133.1587983444784;
        Mon, 27 Apr 2020 03:30:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m29sm9819757ljc.24.2020.04.27.03.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 03:30:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 310451814FF; Mon, 27 Apr 2020 12:30:41 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC v1] net: xdp: allow for layer 3 packets in generic skb handler
In-Reply-To: <CAHmME9qXrb0ktCTeMJwt6KRsQxOWkiUNL6PNwb1CT7AK4WsVPA@mail.gmail.com>
References: <20200427011002.320081-1-Jason@zx2c4.com> <87h7x51jjx.fsf@toke.dk> <CAHmME9qXrb0ktCTeMJwt6KRsQxOWkiUNL6PNwb1CT7AK4WsVPA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 27 Apr 2020 12:30:41 +0200
Message-ID: <87wo61z0dq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> (2) is infeasible, but there's another option: we can insert a pseudo
> ethernet header during the xdp hook for the case of mac_len==0. I'll
> play with that and send an RFC.

Oh, right, that might work too! :)

-Toke

