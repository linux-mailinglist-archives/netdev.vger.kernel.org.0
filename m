Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264AD6E28E0
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjDNRBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjDNRBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:01:15 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6099DAF1D
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:01:04 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id lh8so5926841plb.1
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1681491663; x=1684083663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DCiPADMR9pAaZ6QmtPFG00ZYmKHmpcRN9jgoFRRGwsw=;
        b=wdRzS+lIMlIvaznjD90A4515mzaOT4UkMRxVPDdE3aKszh2u+GMprf2wTODtySuLsH
         vIDQ0p608cVP14ecLcEy7EjY0qvbHuJe7UlXorn30wD19R4B9IfsoSXGfrQq+17sqd/v
         JL6P4LbaQwVDZ2ptf5iwpj+X6DPXfPI++fN1TFbZyKyxQovXNnge5M76Ef+IrcAvBqJb
         VGU/eGT9Jomtd8nRhrWPe7uSkA2plhmwFyNu8HL1Yu9137fwEzuS/syTbGRsVeTjxwGv
         YWX0Ykg1MNfXmlhTIrW+lAwPPMnwGcvMrkObgRO/HGcy8N5e2H7M2bP03B8qpy2o9GKi
         nO4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681491663; x=1684083663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DCiPADMR9pAaZ6QmtPFG00ZYmKHmpcRN9jgoFRRGwsw=;
        b=jvR6mDMGFDWkDTl9iICTsahT0+slMOgykep3IsY3jbv8j8zce984neZw4Kehla8u8I
         Q0451WJO/yFxzJEC6TacVoghsmFmDLiLu+70VllsvgzS+v1av1ypdyz4CSqooxZzdxGq
         6AlFsdt2bEK66IaBhCa2dZmzbk8ZBzCWfhCoAanzC1GMT3804RB7CN/SsazhpuIb0pZi
         SQoItQIswFs53hs1q3CoL19WsYuuI24y6PVgb8jllb6bm/dc5hPGUrNs30/gBWebVamg
         4ClcpGs/sq3TYofv9jKDTVMNDuBmZAfquex3AARgqa19LrwlvCTeB6hvv7aMC6zQt+W/
         7+Cw==
X-Gm-Message-State: AAQBX9cL/qdjQUW2bFV9gSE24z2XJQATBGHAhoqzIT3SgtwPNvXN68aS
        zFTfEQfW35PfFwJBPFHb+gzmb3BeMk4cB4hUw4Crng==
X-Google-Smtp-Source: AKy350Y2bX3WPERPFrm3j5pKY4XcXPrV/7YYQFWtSy13q/jbnPPI2afdp1Ib/EyqEBIlrGSXKqHZzA==
X-Received: by 2002:a17:90a:9309:b0:23d:133a:62cc with SMTP id p9-20020a17090a930900b0023d133a62ccmr6222865pjo.17.1681491663542;
        Fri, 14 Apr 2023 10:01:03 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id fv23-20020a17090b0e9700b002473c9c8d92sm1170358pjb.44.2023.04.14.10.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 10:01:03 -0700 (PDT)
Date:   Fri, 14 Apr 2023 10:01:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Lars Ekman <uablrek@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: iproute2 bug in json output for encap
Message-ID: <20230414100101.16813970@hermes.local>
In-Reply-To: <65b59170-28c2-2e3b-f435-2bdcc6d7b10c@gmail.com>
References: <e3bfc8e6-5522-4e65-373e-976388533765@gmail.com>
        <20230414082103.1b7c0d82@hermes.local>
        <cf099564-2b3c-e525-82cd-2d8065ba7fb3@gmail.com>
        <65b59170-28c2-2e3b-f435-2bdcc6d7b10c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 18:26:03 +0200
Lars Ekman <uablrek@gmail.com> wrote:

> Hi again,
>=20
> Digging a little deeper I see that the double "dst" items will cause
> problems with most (all?) json parsers. I intend to use "go" and json
> parsing will be parsed to a "map" (hash-table) so duplicate keys will
> not work.
>=20
> https://stackoverflow.com/questions/21832701/does-json-syntax-allow-dupli=
cate-keys-in-an-object
>=20
> IMHO it would be better to use a structured "encap" item. Something like;
>=20
> [ {
> =C2=A0=C2=A0=C2=A0 "dst": "192.168.11.0/24",
> =C2=A0=C2=A0 =C2=A0"encap": {
> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 "protocol": "ip6",
> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 "id": 0,
> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 "src": "::",
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "dst": "fd00::c0a8:2dd",
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "hoplimit": 0,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "tc": 0
> =C2=A0=C2=A0 =C2=A0},
> =C2=A0=C2=A0=C2=A0 "scope": "link",
> =C2=A0=C2=A0=C2=A0 "flags": [ ]
> } ]

Something like this?

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 52221c6976b3..37730024caaf 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -834,14 +834,15 @@ static void print_encap_xfrm(FILE *fp, struct rtattr =
*encap)
 void lwt_print_encap(FILE *fp, struct rtattr *encap_type,
 			  struct rtattr *encap)
 {
-	int et;
+	uint16_t et;
=20
 	if (!encap_type)
 		return;
=20
 	et =3D rta_getattr_u16(encap_type);
-
-	print_string(PRINT_ANY, "encap", " encap %s ", format_encap_type(et));
+	open_json_object("encap");
+	print_string(PRINT_ANY, "encap_type", " encap %s ",
+		     format_encap_type(et));
=20
 	switch (et) {
 	case LWTUNNEL_ENCAP_MPLS:
@@ -875,6 +876,7 @@ void lwt_print_encap(FILE *fp, struct rtattr *encap_typ=
e,
 		print_encap_xfrm(fp, encap);
 		break;
 	}
+	close_json_object();
 }
=20
 static struct ipv6_sr_hdr *parse_srh(char *segbuf, int hmac, bool encap)
