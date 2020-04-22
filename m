Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613521B48AF
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgDVPdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgDVPdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:33:05 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51EEC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 08:33:04 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id l25so2813913qkk.3
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 08:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3XyjPYn1ZstDYRdTA0SVbrrlal6xVE/+9BBznEYwI3U=;
        b=niGjubiWP+ljGoo6JfuCLby2z2P9656KewqSam628miMhFRayAYZEKMpVJ1H4T2Cvs
         0t8zxRjfiO8dqtMXBtLexM6jwmE2ePOqhz59oaWXDM59s/jvZI8+0kxKYcFdvi/HKNXN
         KFuXCnaGv48g9FMpIWBNtS9h0cJOY3WsSLFXVxWt6KlWicA8k3aUcqwzPjN/QifpWb+d
         zI1bfZkNQJdlMG6fHifJfpX7vPsnnfLJ9rbEl9rx7TehZ2KTQCFi6n6mOlY2hwcw9LAb
         acn1xa+QcQfZ0hWjCgZwxWMgrtj9knJnvsLhoNtNamNEuHvhEoTLaK4HJAi/uJzej+GM
         +V1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3XyjPYn1ZstDYRdTA0SVbrrlal6xVE/+9BBznEYwI3U=;
        b=KM0ExGXW1fEKBoe0uY/2MVSAIYEOezdD+UbSu85Ui/H8dHODot1FbT0YLemfmNCuQQ
         V6DBdeUUupPw643r7WqFtNPpoGcb9sZav7DKsoX4AKpc7+ezRwEoawUeNiX1YUHU1yHW
         YTTtuxHfLpUnUdrC/YzyUlTiBqOSwzTKzQHo2s91waj9wnxSZugWcBbXS2ttj2KsTtIU
         wbL/JdtqUDTp5OAwHZX4SkQIkHiUL//WMUwdzbfhK5NW0sg/n9/TUkyDlpcSib1NLpAH
         AFrspib2jEtxpmbJDudRmwAgt0wJ2LdeCzVZQLCdwVUfW6vIONt/pX+C+z+6vBRONiFJ
         hD+w==
X-Gm-Message-State: AGi0PuZSKW00NzmAGwCimVF3nBtIrMAcXKbELOlwV3QXU4FbtZJ9+KxM
        TnoDS4hkFOicZONOyZPQzTo=
X-Google-Smtp-Source: APiQypLutC7zMPE80VSnE4FSz/vDNAxiumbV6tjC7wD6uX/bGQ6IbuelYe8CqJ+fBHaToCiUes2eQQ==
X-Received: by 2002:a37:98d:: with SMTP id 135mr26305418qkj.377.1587569584011;
        Wed, 22 Apr 2020 08:33:04 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19e:4650:3a73:fee4? ([2601:282:803:7700:c19e:4650:3a73:fee4])
        by smtp.googlemail.com with ESMTPSA id d4sm4216918qtc.48.2020.04.22.08.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 08:33:02 -0700 (PDT)
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
 <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com> <87k1277om2.fsf@toke.dk>
 <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com> <875zdr8rrx.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com>
Date:   Wed, 22 Apr 2020 09:33:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <875zdr8rrx.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/20 9:27 AM, Toke Høiland-Jørgensen wrote:
> And as I said in the beginning, I'm perfectly happy to be told why I'm
> wrong; but so far you have just been arguing that I'm out of scope ;)

you are arguing about a suspected bug with existing code that is no way
touched or modified by this patch set, so yes it is out of scope.

The proper way to discuss a bug in existing code is a thread focused on
that topic, not buried inside comments on a patch set.
