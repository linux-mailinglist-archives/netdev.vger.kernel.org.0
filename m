Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2195D4DE2C
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbfFUAtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:49:45 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:46563 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfFUAtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:49:45 -0400
Received: by mail-io1-f54.google.com with SMTP id i10so155987iol.13
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fCNHOZHMZbkI2r13lZfSqE17QUXUQLFaOs3rdEwJpus=;
        b=IGxqFxBxOptZk5udL8dE4lm+pE+RCYWyMHTJDGvn8C3Tfq7sOTUyBPSoHlLqpenFds
         pztZvILOv+uRerFQgRTtGEh5DoiKbwXSeM/OOfHwbTtNuJ3oW/ykAAoW7HS2EkelU0lj
         QrAM5OwpbnmO/j/o5WcdMR9jVWXtA1ytD/l8LCFFEev1Q2irfKHHw1SjjxkllEgSpZZo
         lbOeJlP7ymRufmnR5QX9D6OxfqPARszGNIDcyW+NzKrezmOMK130esomdzMKH7orQo5A
         IEqoSDqYJKUNqQOPBkyoynQ91foMI+iz/NvWROHd3UR/upZ3QGb3MixPFqRToir28dg+
         ksdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fCNHOZHMZbkI2r13lZfSqE17QUXUQLFaOs3rdEwJpus=;
        b=DNERrQbEL5kPcybdCOntltxuspZE+cdXBeWXkBkYR09+1Cx9v1YNeptygiJKnbtcVQ
         ZAWMGsPdY2WeuI9vlICKk4oEI/g13SruDhD3biEUs+8fGPV1HkaNXEHfqP5FsPFggahN
         to8lnOWhgKj7fkkD8cTfwUnSKd3k8TPTq2mXteAJAX0qyxqg1i+dWEPcT163vVRWF6XL
         V84CJnIE6fPL+8FrLBlZBd0B2+VWR3vNSTWA3IK1Zm/AzhzBaAjdZG9hGVv76qDdgUzf
         KE8OGHPLBjdnVsFgHEBspM1PP62tvFXi1DX0cAe/0s5FcGCPd+mDC59DX10Y8cLjBUsy
         jKIw==
X-Gm-Message-State: APjAAAVdb/pOyAE9VRRigBQkysIkKGZuYf7Aa5smZgybJxasZHCIQjOo
        WPGhTpJxKiLG+BCYGDn/3gt5PViz
X-Google-Smtp-Source: APXvYqxH8+H9FT9zH21j/35x/Xzu8F1AODugL2iGQ6Ym7P+SabPBsYmRexEkTiLMzFC1NcLPYjwJLQ==
X-Received: by 2002:a5d:9448:: with SMTP id x8mr22299537ior.102.1561077740103;
        Thu, 20 Jun 2019 17:42:20 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:4cec:f7ec:4bbc:cb19? ([2601:284:8200:5cfb:4cec:f7ec:4bbc:cb19])
        by smtp.googlemail.com with ESMTPSA id w23sm1212906iod.12.2019.06.20.17.42.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 17:42:19 -0700 (PDT)
Subject: Re: Stats for XDP actions
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Miller <davem@davemloft.net>, mst@redhat.com,
        makita.toshiaki@lab.ntt.co.jp, jasowang@redhat.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        hawk@kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
References: <1548934830-2389-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <20190131101516-mutt-send-email-mst@kernel.org>
 <20190131.094523.2248120325911339180.davem@davemloft.net>
 <20190131211555.3b15c81f@carbon>
 <b8c97120-851f-450f-dc71-59350236329e@gmail.com>
 <20190204125307.08492005@redhat.com>
 <bdcfedd6-465d-4485-e268-25c4ce6b9fcf@gmail.com> <87tvevpf0y.fsf@toke.dk>
 <44ae964a-d3dd-6b7f-4bcc-21e07525bf41@gmail.com> <87sgs46la6.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cd9136ff-4127-72a5-0857-2e5641ba5252@gmail.com>
Date:   Thu, 20 Jun 2019 18:42:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <87sgs46la6.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 2:42 PM, Toke Høiland-Jørgensen wrote:
>>> I don't recall seeing any follow-up on this. Did you have a chance to
>>> formulate your ideas? :)
>>>
>>
>> Not yet. Almost done with the nexthop changes. Once that is out of the
>> way I can come back to this.
> 
> Ping? :)
> 

Definitely back to this after the July 4th holiday.
