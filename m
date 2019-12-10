Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B81C3118F50
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfLJRvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:51:10 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:42803 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbfLJRvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:51:10 -0500
Received: by mail-pj1-f65.google.com with SMTP id o11so7683103pjp.9
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 09:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=QXn1RGPwZ6zXKbwhoYm49pCMZGeX4H/5cWHqgx7PCfM=;
        b=IpiSSd7EmETipQvWoJpINVoRETxT/2c+DqXroUQCDRSFC1qcm6iIT5h9CzBpIBcJTe
         YYJBzvl4ak2xqjymy/vaFJAv3eX383SRXgMKWWT/rEUFG6594OHOQflAPXdCIgVLwD07
         F470FLKeB4NQy1dISeww6JxRuHhE5uzASfv7hOohNdsp7AL2o0of7erlhaYInWg0atFe
         2YIBqzMeon+NVBG9UFuh0nyYceM56KeNiAMr2aP2qth+c00vgWtXheK+sBOJWXAbywfh
         vhg50TUEhalnUnT3B2idrNxlbg4gqnCxfNgSj/r0ig2/uXDO3bjU5h7GMQjbDqrcO61e
         wvpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QXn1RGPwZ6zXKbwhoYm49pCMZGeX4H/5cWHqgx7PCfM=;
        b=jNX7qAeoAbPzN9KHZ9Oxpg0HWwQQdb/Jf61Uud7/AXTtSX4lJuBAvl2XgTfE1DIpMN
         wzkBgmP0DCRZBgNJwTFrkTgKifnydIYD1MVxQFW28P/K2WW/t6xhyliSv9kXwA/E4PMB
         sg1jUfTwOp1CNKpoMahjpBffq+BP8ga6k/aFijjgbYqKFrr59RYO7b/BhEjQ+OVgDSLz
         lvlHu4V/EclgYFXM3BBXSChGYVSEZSc8xtKVUiI4nO+6kIIvsCvmcem41m9H/stNN99E
         5U+qaNwg87sssExCQxBaQewLDVT438KH29lCT8eQCs83n2i/0wK3XXA3e2c0Eoq2wSUd
         ys+w==
X-Gm-Message-State: APjAAAXXM3jkPgUtkod0JzyRwr8cxyGqkXdSYlTj+yeJ9FSxwQhJsaDm
        BPT/HplnBhUVV13cH4VAc+I2FA==
X-Google-Smtp-Source: APXvYqz/h9LdkRG/9mdmSb3sZOuOaDargusiL1V6eXZ2gP9seg20uZFSaxbroaBIHgneLQTU7NTyPA==
X-Received: by 2002:a17:90a:e98d:: with SMTP id v13mr6825670pjy.107.1576000268735;
        Tue, 10 Dec 2019 09:51:08 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::3])
        by smtp.gmail.com with ESMTPSA id i26sm4057278pfr.151.2019.12.10.09.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 09:51:08 -0800 (PST)
Date:   Tue, 10 Dec 2019 09:51:05 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/5] rtnetlink: provide permanent hardware
 address in RTM_NEWLINK
Message-ID: <20191210095105.1f0008f5@cakuba.netronome.com>
In-Reply-To: <7c28b1aa87436515de39e04206db36f6f374dc2f.1575982069.git.mkubecek@suse.cz>
References: <cover.1575982069.git.mkubecek@suse.cz>
        <7c28b1aa87436515de39e04206db36f6f374dc2f.1575982069.git.mkubecek@suse.cz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 14:07:53 +0100 (CET), Michal Kubecek wrote:
> @@ -1822,6 +1826,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX=
+1] =3D {
>  	[IFLA_PROP_LIST]	=3D { .type =3D NLA_NESTED },
>  	[IFLA_ALT_IFNAME]	=3D { .type =3D NLA_STRING,
>  				    .len =3D ALTIFNAMSIZ - 1 },
> +	[IFLA_PERM_ADDRESS]	=3D { .type =3D NLA_REJECT },
>  };
> =20
>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] =3D {

Jiri, I just noticed ifla_policy didn't get strict_start_type set when
ALT_IFNAME was added, should we add it in net? =F0=9F=A4=94
