Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C704096AFA
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbfHTU6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:58:16 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40951 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730798AbfHTU6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 16:58:16 -0400
Received: by mail-qk1-f196.google.com with SMTP id s145so5745774qke.7
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 13:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=SqLWJh0GResoA/2lcZM6Nsi3D2dP60lqXx/h+Yc5Tso=;
        b=G1apOVnxha95rns3MpqVTl+QjHyTHzDR8E4K0dLCccQT+VdZWnCZa3ZpopMffW5TX4
         zYkPbUhj8PQRbOsJf/XjtWDyZVyGvG+imsIMv46QTLMgLDJEgR9AO44XTWMly63hzAMs
         a7H66mrabNiv2cQtyXTTQgSplvnFTyFQoWhcPo5c7n05126iOZFwCZXTeNx4+ZaHaKNc
         eNQjQZR0U6UcidR0INE7N6J0J/1uHJJN5AIQrBYAyXOfap/dKn8s99BddQJaHebmqcxM
         DZI6EtzLe+7PGPIgYd3iIjqkf1Z95lSGlQuWxaEZuw84KO2Stm2wglqZDzvTfdUpqrl0
         ZZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=SqLWJh0GResoA/2lcZM6Nsi3D2dP60lqXx/h+Yc5Tso=;
        b=kkwnve9XkAF17w0aWDKGGJVSLflO5Wkg6CU7UZKQn/Uj2mK+6/EUz3iyn9BGjbNXBK
         S3KFSxyTVa71j/Dyd6MD7yyB+75iSXqj5wS5uHv2RDxhAqDVUqR1mhEaxecdXhIE3WzB
         K00IxqpJAdK9706sJKLVmklZOqmi+36eLYOjF3zkZAvRB94EHyjYiuCqsWifFXJ8mjlE
         F9M+no1YrD4pnB9VPJE1RFMC6KtxX7cqZ7dSGNYtAaaDwXj2XA01pz6K3GBVq1FyRPdJ
         r34mLFskWL4x9Fe0kWxcZ4uG1P4uVko5EtjOcPbpU/NGnr678tC31oVHawREa0tPEDpJ
         RBDQ==
X-Gm-Message-State: APjAAAVCeSCC9oaiCWNvJFXg1LfnEg8T7m6T7Q6RfHERbb5l3jgD5AAc
        P/08wNXoq9qB2C/B3tT7FgYFe24y7p4=
X-Google-Smtp-Source: APXvYqzhwJUCX9XhpN061LSXqQGBR9svGeblYQn7ct4kCFMCz/7r3D3ozxqo4ZBP215McLlOTKDkhQ==
X-Received: by 2002:a37:a6d8:: with SMTP id p207mr25382452qke.387.1566334695375;
        Tue, 20 Aug 2019 13:58:15 -0700 (PDT)
Received: from localhost (mtrlpq2853w-lp130-05-67-70-100-98.dsl.bell.ca. [67.70.100.98])
        by smtp.gmail.com with ESMTPSA id x14sm8738599qkj.95.2019.08.20.13.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:58:14 -0700 (PDT)
Date:   Tue, 20 Aug 2019 16:58:13 -0400
Message-ID: <20190820165813.GB8523@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/6] net: dsa: Delete the VID from the upstream
 port as well
In-Reply-To: <CA+h21hqdXP1DnCxwuZOCs4H6MtwzjCnjkBf3ibt+JmnZMEFe=g@mail.gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-4-olteanv@gmail.com>
 <20190820015138.GB975@t480s.localdomain>
 <CA+h21hpdDuoR5nj98EC+-W4HoBs35e_rURS1LD1jJWF5pkty9w@mail.gmail.com>
 <20190820135213.GB11752@t480s.localdomain>
 <c359e0ca-c770-19da-7a3a-a3173d36a12d@gmail.com>
 <CA+h21hqdXP1DnCxwuZOCs4H6MtwzjCnjkBf3ibt+JmnZMEFe=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 23:40:34 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> I don't need this patch. I'm not sure what my thought process was at
> the time I added it to the patchset.
> I'm still interested in getting rid of the vlan bitmap through other
> means (picking up your old changeset). Could you take a look at my
> questions in that thread? I'm not sure I understand what the user
> interaction is supposed to look like for configuring CPU/DSA ports.

What do you mean by getting rid of the vlan bitmap? What do you need exactly?
