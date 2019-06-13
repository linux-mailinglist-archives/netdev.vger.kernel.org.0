Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07851437C1
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732573AbfFMPBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:01:00 -0400
Received: from mout.web.de ([212.227.15.3]:43807 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732567AbfFMOkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 10:40:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1560436834;
        bh=nQXaXhEn5K6+MC6V78vzRIvLgHWx2mtv7BkkzhMCFho=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=LSgSErSfGW9XjzbU0dXsCu1We4EWGZUUGhsBAem2zhyPpbEBO3TR3IpI7PgqZ+Vv+
         6pTRNemTS1mjw2gm4GS6UgimQavSA+v1ZjKjMnf5f5f/q5KBTbsuN7FvicZ7qAJEmU
         QZOghi3LzXyoayQycaT+ENHGIvkajKWz8tPy8HmA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.13.40]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LwI2w-1iiFH22jQE-0180dx; Thu, 13
 Jun 2019 16:40:34 +0200
Subject: Re: ss: Checking efficient analysis for network connections
To:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Josh Hunt <johunt@akamai.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1556674718-5081-1-git-send-email-johunt@akamai.com>
 <3d1c67c8-7dfe-905b-4548-dae23592edc5@web.de>
 <20190601.164838.1496580524715275443.davem@davemloft.net>
From:   Markus Elfring <Markus.Elfring@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <26253062-c1c5-c9e3-fd0e-bc27b713680e@web.de>
Date:   Thu, 13 Jun 2019 16:40:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190601.164838.1496580524715275443.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VJB0x8dDFvfL5SviArKqC9ONxnDXjCHn7k0wnsFoKn2F/cMnGrq
 SFoOldihNrugjQeNd06EGOD9Lm4EEjr9tqNOqA8Fw0RlxPFrMQ6X7olL+zE5/2Lrzxzq7ua
 RHs4BzgzY193b7TAr1WkDRes08k+uORFWmlgzAwLj6oqoTr0S66tdCA40FebXvElTad2YVW
 sfuPeib2PSRx78hxjxv9A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:84Cm9PqejcI=:aZ2K/Lh8GYxkwa1EX6sPk2
 CZNKAvx1HOP03OEl/oUQgusPSPWDy7w1iSzMn7b12fw+Ff9xoUcW/xEihGwUSCd3gzX1eQYWG
 V9B8HD9SRxy1x+qj4O7dHkJr0cdAyhycmP+6Hz+hQ//AA3th2M+AWWBfLao95qDlYxs41XCAH
 H7XsFDDuB6g73QnueQ1+GA448bPM92fca45s6TIW8lLjKaA1i6aom5QWr+DgOqcpGC7U6IsS+
 spPc1ho3amtfM4l353g4UoE6+/EYZe9YVks5CzuWBV2qwqj/+Anhypx9WDjxZvPqpAsjbKA2a
 5h1ilaE8NGlAj085zhv6kbad+rmcWM2g9vP/NaSLuKc78tI5d3rDmKH1UUX3o5y9h24sLD/34
 nr25VnllzkmpiCgGgwfsF2AnIwjXOsvLwpGDQtG+t0IX7QAigLKhZ219yEmaqBAErJkNIejoZ
 pSS7YQZ9LJ20Nhd6o1Gqh4s6qjAXNvQ0NwP89XQWXxLyFi3DPrjDlxO357cUMzUW4eli2bCTL
 F3um9W/1srImoMZ74K14g9sNona5EXA+207woT4AYeJJMacuaXDVhGGx8CCvhkAl/r+c6Okre
 /e981viof5tOjdsZk5cva6YuNwMe/zSR3g09x2IBD1IoxxD0CH/d4DAxSL3vn1cKRHa4jQ2QV
 Y2pZjW5c6UoNFYY64ol2RsNKMbw6frIhUwPvRs55qrvH0DhE3LrCqhCwXkA/YQUhoYOeQv533
 2uUN+jurKFLdhvO7+/GG2OTvsXf0XbHWeYTgEv2dsSUvNOVr3YmZ/hy0rrQjGWPjo7RJFpldg
 N4vnrlLOjAeZwHoXAyhSLJ2cnrFu1N8+h1Lz3A2sufzknq331vRFh5XqfANZ+uUH4+OWuO4cH
 ua+g1F8ZFx113L4RgvNU0e8IP4p6f1silVLxaojA5aho2E0pDkZVvjxfaNFUarW6gWOb/tEJ9
 OHR7rFyPCluEJ4ROlOEescKkwpG4iszxIUAHqQRUaxbgiG0qLMaw+
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This whole discussion has zero to do with what text format 'ss' outputs.

Would you like to support the clarification of additional data formats
for the usage of specific information by tools for socket statistics
(from the directory =E2=80=9C/proc/net=E2=80=9D and related ones)?

Regards,
Markus
