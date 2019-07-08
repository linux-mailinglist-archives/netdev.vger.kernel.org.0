Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537B3627BD
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 19:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbfGHRyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 13:54:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41843 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732420AbfGHRyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 13:54:50 -0400
Received: by mail-qt1-f193.google.com with SMTP id d17so17505640qtj.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 10:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pjUKYFfrPOyRPh7bu1OgTOJa9phpVsHoUi8n0k3sask=;
        b=iEy2Lvfza/T/WCZP4hmx+cyfo8jbMWqfV0OyQBn9XFESl/LjVntq5QI3rpDWyZDseQ
         wTTLN+LgRIKKk+RIhyOVDukbNEfeWco0a2s40DE9h6+11HRp3mOv89zNYhIYow9mqGV4
         vipLU2py5JFqbslFZDy+8uRrWMtSdwtT/Q8siwHOcH5EXaBU5+dBbTS9gB0d1D/An+Dr
         eGDALf/+P57TaAFJfOXY4uzCx9P9UjEm7KSnaKmR+SS96kRa+3Qz39wJkQ0ff8k1iCEm
         nNpyTIw5SbvUw4eg2xfHg232ifNZadrX04vzendUHbtOVck/rqFWtl+PsMHBpxgW/elj
         Pq3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pjUKYFfrPOyRPh7bu1OgTOJa9phpVsHoUi8n0k3sask=;
        b=YW9dd6sFH4YCvjdkBJFBGAKlASy4mXTwGcscY7k0++ZIlyY4Er3zOEvjPDAFpwbiLd
         xtODvGb2Eeuhn/q6k8wudyZGeNB0KTM2DIImJHsJ/M6FhIUdtv9kyEhwXwyDmtltgcZx
         zj5iFlijrmWeuzO7zZjNn+v10dOCIRLmaGB/E99ClQI5tBV02UEi6bU7A13vBUr8VzAE
         kLtQfgtSYVCBsGhyYlnb8dPBQogAXHHEXfvoj8neMt/isO5M91Uk36Qs70MCYPuPzttK
         uV1Gk1nBoUmmNqzGKxDNW/UP5niWATtKqeNlCVCAWdz5V1Izj1SdcNvJh3gDtuiE0XVa
         aMOw==
X-Gm-Message-State: APjAAAUI8+MOQBpZsh/P1Tb7i0JBdMPQbaLqi384VFV61dgmsAbj2wW3
        nfEnQpP1JzmBQ+TSFFyzL78=
X-Google-Smtp-Source: APXvYqyMURFmoKUzXB4PZHXn5vzOBemelvDHN/p8bgP6W5wJDq9Czip+43AkAqNWJEeVKaOM/OkjEA==
X-Received: by 2002:a0c:bd1f:: with SMTP id m31mr16046862qvg.54.1562608489296;
        Mon, 08 Jul 2019 10:54:49 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:5853:8fda:3106:4b2a:a3ee])
        by smtp.gmail.com with ESMTPSA id c26sm7479317qtp.40.2019.07.08.10.54.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 10:54:48 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 21013C0A68; Mon,  8 Jul 2019 14:54:46 -0300 (-03)
Date:   Mon, 8 Jul 2019 14:54:46 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>, Justin Pettit <jpettit@ovn.org>,
        John Hurley <john.hurley@netronome.com>,
        Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net-next iproute2 2/3] tc: Introduce tc ct action
Message-ID: <20190708175446.GL3449@localhost.localdomain>
References: <1562489628-5925-1-git-send-email-paulb@mellanox.com>
 <1562489628-5925-3-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562489628-5925-3-git-send-email-paulb@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 07, 2019 at 11:53:47AM +0300, Paul Blakey wrote:
> New tc action to send packets to conntrack module, commit
> them, and set a zone, labels, mark, and nat on the connection.
> 
> It can also clear the packet's conntrack state by using clear.
> 
> Usage:
>    ct clear
>    ct commit [force] [zone] [mark] [label] [nat]

Isn't the 'commit' also optional? More like
    ct [commit [force]] [zone] [mark] [label] [nat]

>    ct [nat] [zone]
> 
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Yossi Kuperman <yossiku@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Acked-by: Roi Dayan <roid@mellanox.com>
> ---
...
> +static void
> +usage(void)
> +{
> +	fprintf(stderr,
> +		"Usage: ct clear\n"
> +		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC]\n"

Ditto here then.

> +		"	ct [nat] [zone ZONE]\n"
> +		"Where: ZONE is the conntrack zone table number\n"
> +		"	NAT_SPEC is {src|dst} addr addr1[-addr2] [port port1[-port2]]\n"
> +		"\n");
> +	exit(-1);
> +}
...

The validation below doesn't enforce that commit must be there for
such case.

> +static int
> +parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
> +		struct nlmsghdr *n)
> +{
> +	struct tc_ct sel = {};
> +	char **argv = *argv_p;
> +	struct rtattr *tail;
> +	int argc = *argc_p;
> +	int ct_action = 0;
> +	int ret;
> +
> +	tail = addattr_nest(n, MAX_MSG, tca_id);
> +
> +	if (argc && matches(*argv, "ct") == 0)
> +		NEXT_ARG_FWD();
> +
> +	while (argc > 0) {
> +		if (matches(*argv, "zone") == 0) {
> +			NEXT_ARG();
> +
> +			if (ct_parse_u16(*argv,
> +					 TCA_CT_ZONE, TCA_CT_UNSPEC, n)) {
> +				fprintf(stderr, "ct: Illegal \"zone\"\n");
> +				return -1;
> +			}
> +		} else if (matches(*argv, "nat") == 0) {
> +			ct_action |= TCA_CT_ACT_NAT;
> +
> +			NEXT_ARG();
> +			if (matches(*argv, "src") == 0)
> +				ct_action |= TCA_CT_ACT_NAT_SRC;
> +			else if (matches(*argv, "dst") == 0)
> +				ct_action |= TCA_CT_ACT_NAT_DST;
> +			else
> +				continue;
> +
> +			NEXT_ARG();
> +			if (matches(*argv, "addr") != 0)
> +				usage();
> +
> +			NEXT_ARG();
> +			ret = ct_parse_nat_addr_range(*argv, n);
> +			if (ret) {
> +				fprintf(stderr, "ct: Illegal nat address range\n");
> +				return -1;
> +			}
> +
> +			NEXT_ARG_FWD();
> +			if (matches(*argv, "port") != 0)
> +				continue;
> +
> +			NEXT_ARG();
> +			ret = ct_parse_nat_port_range(*argv, n);
> +			if (ret) {
> +				fprintf(stderr, "ct: Illegal nat port range\n");
> +				return -1;
> +			}
> +		} else if (matches(*argv, "clear") == 0) {
> +			ct_action |= TCA_CT_ACT_CLEAR;
> +		} else if (matches(*argv, "commit") == 0) {
> +			ct_action |= TCA_CT_ACT_COMMIT;
> +		} else if (matches(*argv, "force") == 0) {
> +			ct_action |= TCA_CT_ACT_FORCE;
> +		} else if (matches(*argv, "index") == 0) {
> +			NEXT_ARG();
> +			if (get_u32(&sel.index, *argv, 10)) {
> +				fprintf(stderr, "ct: Illegal \"index\"\n");
> +				return -1;
> +			}
> +		} else if (matches(*argv, "mark") == 0) {
> +			NEXT_ARG();
> +
> +			ret = ct_parse_mark(*argv, n);
> +			if (ret) {
> +				fprintf(stderr, "ct: Illegal \"mark\"\n");
> +				return -1;
> +			}
> +		} else if (matches(*argv, "label") == 0) {
> +			NEXT_ARG();
> +
> +			ret = ct_parse_labels(*argv, n);
> +			if (ret) {
> +				fprintf(stderr, "ct: Illegal \"label\"\n");
> +				return -1;
> +			}
> +		} else if (matches(*argv, "help") == 0) {
> +			usage();
> +		} else {
> +			break;
> +		}
> +		NEXT_ARG_FWD();
> +	}
> +
> +	if (ct_action & TCA_CT_ACT_CLEAR &&
> +	    ct_action & ~TCA_CT_ACT_CLEAR) {
> +		fprintf(stderr, "ct: clear can only be used alone\n");
> +		return -1;
> +	}
> +
> +	if (ct_action & TCA_CT_ACT_NAT_SRC &&
> +	    ct_action & TCA_CT_ACT_NAT_DST) {
> +		fprintf(stderr, "ct: src and dst nat can't be used together\n");
> +		return -1;
> +	}
> +
> +	if ((ct_action & TCA_CT_ACT_COMMIT) &&
> +	    (ct_action & TCA_CT_ACT_NAT) &&
> +	    !(ct_action & (TCA_CT_ACT_NAT_SRC | TCA_CT_ACT_NAT_DST))) {
> +		fprintf(stderr, "ct: commit and nat must set src or dst\n");
> +		return -1;
> +	}
> +
> +	if (!(ct_action & TCA_CT_ACT_COMMIT) &&
> +	    (ct_action & (TCA_CT_ACT_NAT_SRC | TCA_CT_ACT_NAT_DST))) {
> +		fprintf(stderr, "ct: src or dst is only valid if commit is set\n");
> +		return -1;
> +	}
> +
> +	parse_action_control_dflt(&argc, &argv, &sel.action, false,
> +				  TC_ACT_PIPE);
> +	NEXT_ARG_FWD();
> +
> +	addattr16(n, MAX_MSG, TCA_CT_ACTION, ct_action);
> +	addattr_l(n, MAX_MSG, TCA_CT_PARMS, &sel, sizeof(sel));
> +	addattr_nest_end(n, tail);
> +
> +	*argc_p = argc;
> +	*argv_p = argv;
> +	return 0;
> +}
...
